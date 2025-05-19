package daocond

import (
	"errors"
	"math"

	"gno.land/p/demo/ufmt"
)

type roleThresholdCond struct {
	hasRoleFn        func(memberId string, role string) bool
	usersRoleCountFn func(role string) uint32
	threshold        float64
	role             string
}

func RoleThreshold(threshold float64, role string, hasRoleFn func(memberId string, role string) bool, usersRoleCountFn func(role string) uint32) Condition {
	if threshold <= 0 || threshold > 1 {
		panic(errors.New("invalid threshold"))
	}
	if hasRoleFn == nil {
		panic(errors.New("nil hasRoleFn"))
	}
	if usersRoleCountFn == nil {
		panic(errors.New("nil usersRoleCountFn"))
	}
	return &roleThresholdCond{
		threshold:        threshold,
		hasRoleFn:        hasRoleFn,
		usersRoleCountFn: usersRoleCountFn,
		role:             role,
	}
}

// Eval implements Condition.
func (c *roleThresholdCond) Eval(votes map[string]Vote) bool {
	return c.yesRatio(votes) >= c.threshold
}

// Signal implements Condition.
func (c *roleThresholdCond) Signal(votes map[string]Vote) float64 {
	return math.Min(c.yesRatio(votes)/c.threshold, 1)
}

// Render implements Condition.
func (c *roleThresholdCond) Render() string {
	return ufmt.Sprintf("%g%% of %s members", c.threshold*100, c.role)
}

// RenderWithVotes implements Condition.
func (c *roleThresholdCond) RenderWithVotes(votes map[string]Vote) string {
	s := ""
	s += ufmt.Sprintf("To meet the condition, %g%% of %s members with role %s must vote yes\n\n", c.threshold*100, c.role)
	s += ufmt.Sprintf("Yes: %d/%d = %g%%\n\n", c.totalYes(votes), c.usersRoleCountFn(c.role), c.yesRatio(votes)*100)
	return s
}

var _ Condition = (*roleThresholdCond)(nil)

func (c *roleThresholdCond) yesRatio(votes map[string]Vote) float64 {
	return float64(c.totalYes(votes)) / float64(c.usersRoleCountFn(c.role))
}

func (c *roleThresholdCond) totalYes(votes map[string]Vote) uint32 {
	totalYes := uint32(0)
	for userId, vote := range votes {
		if vote != VoteYes {
			continue
		}
		if !c.hasRoleFn(userId, c.role) {
			continue
		}
		totalYes += 1
	}
	return totalYes
}
