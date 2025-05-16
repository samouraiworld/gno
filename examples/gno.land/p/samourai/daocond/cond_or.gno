package daocond

import (
	"math"

	"gno.land/p/demo/json"
)

type orCond struct {
	// XXX: use c slice instead of only two children?
	left  Condition
	right Condition
}

func Or(left Condition, right Condition) Condition {
	if left == nil || right == nil {
		panic("left or right is nil")
	}
	return &orCond{left: left, right: right}
}

// Render implements Condition.
func (c *orCond) Render() string {
	return "[" + c.left.Render() + " OR " + c.right.Render() + "]"
}

// RenderJSON implements Condition.
func (c *orCond) RenderJSON() *json.Node {
	return json.ObjectNode("", map[string]*json.Node{
		"type":  json.StringNode("", "or"),
		"left":  c.left.RenderJSON(),
		"right": c.right.RenderJSON(),
	})
}

// Eval implements Condition.
func (c *orCond) Eval(votes map[string]Vote) bool {
	return c.left.Eval(votes) || c.right.Eval(votes)
}

// Signal implements Condition.
func (c *orCond) Signal(votes map[string]Vote) float64 {
	return math.Max(c.left.Signal(votes), c.right.Signal(votes))
}

// RenderJSONWithVotes implements Condition.
func (c *orCond) RenderJSONWithVotes(votes map[string]Vote) *json.Node {
	return json.ObjectNode("", map[string]*json.Node{
		"type":  json.StringNode("", "or"),
		"left":  c.left.RenderJSONWithVotes(votes),
		"right": c.right.RenderJSONWithVotes(votes),
	})
}

var _ Condition = (*orCond)(nil)
