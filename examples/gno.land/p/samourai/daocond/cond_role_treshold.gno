package daocond

import (
	"errors"
	"math"

	"gno.land/p/demo/json"
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

// Render implements Condition.
func (c *roleThresholdCond) Render() string {
	return ufmt.Sprintf("%g%% of %s members", c.threshold*100, c.role)
}

// RenderJSON implements Condition.
func (c *roleThresholdCond) RenderJSON() *json.Node {
	return json.ObjectNode("", map[string]*json.Node{
		"type":      json.StringNode("", "role-threshold"),
		"role":      json.StringNode("", c.role),
		"threshold": json.NumberNode("", c.threshold),
	})
}

// Eval implements Condition.
func (c *roleThresholdCond) Eval(votes map[string]Vote) bool {
	return c.yesRatio(votes) >= c.threshold
}

// Signal implements Condition.
func (c *roleThresholdCond) Signal(votes map[string]Vote) float64 {
	return math.Min(c.yesRatio(votes)/c.threshold, 1)
}

// RenderJSONWithVotes implements Condition.
func (c *roleThresholdCond) RenderJSONWithVotes(votes map[string]Vote) *json.Node {
	return json.ObjectNode("", map[string]*json.Node{
		"type":      json.StringNode("", "role-threshold"),
		"role":      json.StringNode("", c.role),
		"threshold": json.NumberNode("", c.threshold),
		"yes":       json.NumberNode("", float64(c.totalYes(votes))),
		"total":     json.NumberNode("", float64(c.usersRoleCountFn(c.role))),
	})
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
