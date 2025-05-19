package daocond

import (
	"errors"
	"math"

	"gno.land/p/demo/json"
	"gno.land/p/demo/ufmt"
)

type roleCountCond struct {
	hasRoleFn func(memberId string, role string) bool
	count     uint64
	role      string
}

func RoleCount(count uint64, role string, hasRoleFn func(memberId string, role string) bool) Condition {
	if count == 0 {
		panic(errors.New("count must be greater than 0"))
	}
	if role == "" {
		panic(errors.New("role must not be empty"))
	}
	if hasRoleFn == nil {
		panic(errors.New("nil hasRoleFn"))
	}
	return &roleCountCond{
		count:     count,
		hasRoleFn: hasRoleFn,
		role:      role,
	}
}

// Eval implements Condition.
func (c *roleCountCond) Eval(votes map[string]Vote) bool {
	return c.totalYes(votes) >= c.count
}

// Signal implements Condition.
func (c *roleCountCond) Signal(votes map[string]Vote) float64 {
	return math.Min(float64(c.totalYes(votes))/float64(c.count), 1)
}

// Render implements Condition.
func (c *roleCountCond) Render() string {
	return ufmt.Sprintf("%d %s", c.count, c.role)
}

// RenderWithVotes implements Condition.
func (c *roleCountCond) RenderWithVotes(votes map[string]Vote) string {
	s := ""
	s += ufmt.Sprintf("to meet the condition, %d members with role %s must vote yes\n\n", c.count, c.role)
	s += ufmt.Sprintf("Yes: %d/%d\n\n", c.totalYes(votes), c.count)
	return s
}

// RenderJSON implements Condition.
func (c *roleCountCond) RenderJSON() *json.Node {
	return json.ObjectNode("", map[string]*json.Node{
		"type":  json.StringNode("", "role-count"),
		"role":  json.StringNode("", c.role),
		"count": json.NumberNode("", float64(c.count)),
	})
}

// RenderJSONWithVotes implements Condition.
func (c *roleCountCond) RenderJSONWithVotes(votes map[string]Vote) *json.Node {
	return json.ObjectNode("", map[string]*json.Node{
		"type":       json.StringNode("", "role-count"),
		"role":       json.StringNode("", c.role),
		"yes-ratio":  json.StringNode("", ufmt.Sprintf("%d/%d", c.totalYes(votes), c.count)),
		"yes-needed": json.NumberNode("", float64(c.count)),
	})
}

var _ Condition = (*roleCountCond)(nil)

func (c *roleCountCond) totalYes(votes map[string]Vote) uint64 {
	totalYes := uint64(0)
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
