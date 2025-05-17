package main

import (
	"std"

	"gno.land/p/samourai/daokit"
	"gno.land/r/samourai/payrolls"
	"gno.land/r/samourai/samdao"
)

func main() {
	samdao.DAO.Propose(daokit.ProposalRequest{
		Title:       "Add a new payroll for Mikael",
		Description: "Mikael is a member of the Samourai Coop and he is a freelancer. He will be paid 600K ugnot per month.",
		Message: samdao.NewNewPayrollMsg(
			std.Address("g1tqys7x6qmrlx9ed0ja7kj6fmuqa828h58xpj8s"),
			"Monthly Salary",
			payrolls.DistribMonthlyContinuous(std.NewCoins(std.NewCoin("ugnot", 600000))),
			nil,
		),
	})
}
