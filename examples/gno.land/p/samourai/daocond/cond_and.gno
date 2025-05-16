package daocond

import (
	"math"

	"gno.land/p/demo/json"
)

type andCond struct {
	// XXX: use c slice instead of only two children?
	left  Condition
	right Condition
}

func And(left Condition, right Condition) Condition {
	if left == nil || right == nil {
		panic("left or right is nil")
	}
	return &andCond{left: left, right: right}
}

// Render implements Condition.
func (c *andCond) Render() string {
	return "[" + c.left.Render() + " AND " + c.right.Render() + "]"
}

// RenderJSON implements Condition.
func (c *andCond) RenderJSON() *json.Node {
	return json.ObjectNode("", map[string]*json.Node{
		"type":  json.StringNode("", "and"),
		"left":  c.left.RenderJSON(),
		"right": c.right.RenderJSON(),
	})
}

// Eval implements Condition.
func (c *andCond) Eval(votes map[string]Vote) bool {
	return c.left.Eval(votes) && c.right.Eval(votes)
}

// Signal implements Condition.
func (c *andCond) Signal(votes map[string]Vote) float64 {
	return math.Min(c.left.Signal(votes), c.right.Signal(votes))
}

// RenderJSONWithVotes implements Condition.
func (c *andCond) RenderJSONWithVotes(votes map[string]Vote) *json.Node {
	return json.ObjectNode("", map[string]*json.Node{
		"type":  json.StringNode("", "and"),
		"left":  c.left.RenderJSONWithVotes(votes),
		"right": c.right.RenderJSONWithVotes(votes),
	})
}

var _ Condition = (*andCond)(nil)
