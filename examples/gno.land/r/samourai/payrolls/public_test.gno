package payrolls_test

import (
	"std"
	"testing"

	"gno.land/p/demo/testutils"
	"gno.land/p/demo/urequire"
	grc20factory "gno.land/r/demo/grc20factory"
	"gno.land/r/samourai/payrolls"
)

func TestPayrollsGRC20(t *testing.T) {
	monthlyPAY := std.NewCoin("gno.land/r/demo/grc20factory.PAY", 5_000_0000)
	monthlyGRC20s := std.NewCoins(monthlyPAY)
	namespace := "finance"
	monthlyPayrollsCoins, err := payrolls.Coins(nil, monthlyGRC20s)
	urequire.NoError(t, err)

	tokenCreator := testutils.TestAddress("pay-creator")
	payrollsRealm := std.NewCodeRealm("gno.land/r/samourai/payrolls")
	creator := testutils.TestAddress("creator")
	beneficiary := testutils.TestAddress("beneficiary")

	testing.SetOriginCaller(tokenCreator)
	fundAmount := int64(20_000_000)
	cross(grc20factory.New)("Pay", "PAY", 6, 0, fundAmount)

	testing.SetOriginCaller(creator)
	cross(grc20factory.Faucet)("PAY")
	cross(grc20factory.Approve)("PAY", payrollsRealm.Address(), fundAmount)
	cross(payrolls.FundGRC20Reg)(creator.String(), namespace, monthlyPAY.Denom, -1)

	payrollID := cross(payrolls.Create)(namespace, "Salary Monthly", beneficiary,
		payrolls.DistribMonthlyContinuous(monthlyPayrollsCoins),
		payrolls.BreakupCDI(monthlyPayrollsCoins),
	)

	creatorBalance := grc20factory.BalanceOf("PAY", creator)
	urequire.Equal(t, int64(0), creatorBalance)

	realmBalance := grc20factory.BalanceOf("PAY", payrollsRealm.Address())
	urequire.Equal(t, fundAmount, realmBalance)

	skipHeight := uint64(10000)
	testing.SkipHeights(int64(skipHeight))

	urequire.NotPanics(t, func() {
		testing.SetOriginCaller(beneficiary)
		cross(payrolls.Claim)(payrollID, std.Address(""))
	})

	expectedBeneficiaryBalance := int64(964506)

	beneficiaryBalance := grc20factory.BalanceOf("PAY", beneficiary)
	urequire.Equal(t, expectedBeneficiaryBalance, beneficiaryBalance)

	realmBalance = grc20factory.BalanceOf("PAY", payrollsRealm.Address())
	urequire.Equal(t, fundAmount-expectedBeneficiaryBalance, realmBalance)

	urequire.NotAborts(t, func() {
		testing.SetOriginCaller(beneficiary)
		cross(payrolls.Pause)(payrollID)
	})

	testing.SkipHeights(int64(skipHeight))

	urequire.AbortsWithMessage(t, "nothing to claim", func() {
		testing.SetOriginCaller(beneficiary)
		cross(payrolls.Claim)(payrollID, std.Address(""))
	})

	urequire.NotAborts(t, func() {
		testing.SetOriginCaller(beneficiary)
		cross(payrolls.Resume)(payrollID)
	})

	testing.SkipHeights(int64(skipHeight))

	urequire.NotAborts(t, func() {
		testing.SetOriginCaller(creator)
		cross(payrolls.Stop)(payrollID)
	})

	beneficiaryBalance = grc20factory.BalanceOf("PAY", beneficiary)
	urequire.Equal(t, expectedBeneficiaryBalance, beneficiaryBalance)

	realmBalance = grc20factory.BalanceOf("PAY", payrollsRealm.Address())
	urequire.Equal(t, fundAmount-expectedBeneficiaryBalance, realmBalance)

	urequire.NotAborts(t, func() {
		testing.SetOriginCaller(beneficiary)
		cross(payrolls.ClaimAll)(std.Address(""))
	})

	expectedBeneficiaryBalance = int64(1969060)

	beneficiaryBalance = grc20factory.BalanceOf("PAY", beneficiary)
	urequire.Equal(t, expectedBeneficiaryBalance, beneficiaryBalance)

	realmBalance = grc20factory.BalanceOf("PAY", payrollsRealm.Address())
	urequire.Equal(t, fundAmount-expectedBeneficiaryBalance, realmBalance)

	urequire.NotAborts(t, func() {
		testing.SetOriginCaller(creator)
		cross(payrolls.WithdrawFunds)(namespace, monthlyPayrollsCoins[0].Denom, -1, "")
	})

	beneficiaryBalance = grc20factory.BalanceOf("PAY", beneficiary)
	urequire.Equal(t, expectedBeneficiaryBalance, beneficiaryBalance)
	creatorBalance = grc20factory.BalanceOf("PAY", creator)
	urequire.Equal(t, fundAmount-expectedBeneficiaryBalance, creatorBalance)

	urequire.AbortsWithMessage(t, "nothing to claim", func() {
		testing.SetOriginCaller(beneficiary)
		cross(payrolls.ClaimAll)(std.Address(""))
	})
}

func TestPayrollsNative(t *testing.T) {
	monthlyUgnot := std.NewCoin("ugnot", 5_000_0000)
	monthlyNatives := std.NewCoins(monthlyUgnot)
	namespace := "native-finance"
	fundAmount := int64(20_000_000)
	monthlyPayrollsCoins, err := payrolls.Coins(monthlyNatives, nil)
	urequire.NoError(t, err)

	balanceOf := func(addr std.Address) int64 {
		banker := std.NewBanker(std.BankerTypeReadonly)
		return banker.GetCoins(addr).AmountOf(monthlyNatives[0].Denom)
	}

	payrollsRealm := std.NewCodeRealm("gno.land/r/samourai/payrolls")
	creator := testutils.TestAddress("creator")
	beneficiary := testutils.TestAddress("beneficiary")

	testing.SetOriginCaller(creator)
	send := std.NewCoins(std.NewCoin("ugnot", fundAmount))
	testing.IssueCoins(payrollsRealm.Address(), send)
	testing.SetOriginSend(send)

	cross(payrolls.FundNative)(creator.String(), namespace)

	payrollID := cross(payrolls.Create)(namespace, "Salary Monthly", beneficiary,
		payrolls.DistribMonthlyContinuous(monthlyPayrollsCoins),
		payrolls.BreakupCDI(monthlyPayrollsCoins),
	)

	creatorBalance := balanceOf(creator)
	urequire.Equal(t, int64(0), creatorBalance)

	realmBalance := balanceOf(payrollsRealm.Address())
	urequire.Equal(t, fundAmount, realmBalance)

	skipHeight := uint64(10000)
	testing.SkipHeights(int64(skipHeight))

	urequire.NotAborts(t, func() {
		testing.SetOriginCaller(beneficiary)
		cross(payrolls.Claim)(payrollID, std.Address(""))
	})

	expectedBeneficiaryBalance := int64(964506)

	beneficiaryBalance := balanceOf(beneficiary)
	urequire.Equal(t, expectedBeneficiaryBalance, beneficiaryBalance)

	realmBalance = balanceOf(payrollsRealm.Address())
	urequire.Equal(t, fundAmount-expectedBeneficiaryBalance, realmBalance)

	urequire.NotAborts(t, func() {
		testing.SetOriginCaller(beneficiary)
		cross(payrolls.Pause)(payrollID)
	})

	testing.SkipHeights(int64(skipHeight))

	urequire.AbortsWithMessage(t, "nothing to claim", func() {
		testing.SetOriginCaller(beneficiary)
		cross(payrolls.Claim)(payrollID, std.Address(""))
	})

	urequire.NotAborts(t, func() {
		testing.SetOriginCaller(beneficiary)
		cross(payrolls.Resume)(payrollID)
	})

	testing.SkipHeights(int64(skipHeight))

	urequire.NotAborts(t, func() {
		testing.SetOriginCaller(creator)
		cross(payrolls.Stop)(payrollID)
	})

	beneficiaryBalance = balanceOf(beneficiary)
	urequire.Equal(t, expectedBeneficiaryBalance, beneficiaryBalance)

	realmBalance = balanceOf(payrollsRealm.Address())
	urequire.Equal(t, fundAmount-expectedBeneficiaryBalance, realmBalance)

	urequire.NotAborts(t, func() {
		testing.SetOriginCaller(beneficiary)
		cross(payrolls.ClaimAll)(std.Address(""))
	})

	expectedBeneficiaryBalance = int64(1969060)

	beneficiaryBalance = balanceOf(beneficiary)
	urequire.Equal(t, expectedBeneficiaryBalance, beneficiaryBalance)

	realmBalance = balanceOf(payrollsRealm.Address())
	urequire.Equal(t, fundAmount-expectedBeneficiaryBalance, realmBalance)

	urequire.NotAborts(t, func() {
		testing.SetOriginCaller(creator)
		cross(payrolls.WithdrawFunds)(namespace, monthlyPayrollsCoins[0].Denom, -1, "")
	})

	beneficiaryBalance = balanceOf(beneficiary)
	urequire.Equal(t, expectedBeneficiaryBalance, beneficiaryBalance)
	creatorBalance = balanceOf(creator)
	urequire.Equal(t, fundAmount-expectedBeneficiaryBalance, creatorBalance)

	urequire.AbortsWithMessage(t, "nothing to claim", func() {
		testing.SetOriginCaller(beneficiary)
		cross(payrolls.ClaimAll)(std.Address(""))
	})
}
