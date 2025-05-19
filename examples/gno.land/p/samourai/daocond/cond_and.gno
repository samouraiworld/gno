package daocond

import (
	"math"
	"strings"

	"gno.land/p/demo/json"
)

type andCond struct {
	conditions []Condition
}

func And(conditions ...Condition) Condition {
	if len(conditions) < 2 {
		panic("at least two conditions are required")
	}
	return &andCond{conditions: conditions}
}

// Render implements Condition.
func (c *andCond) Render() string {
	renders := []string{}
	for _, condition := range c.conditions {
		renders = append(renders, condition.Render())
	}
	return "[" + strings.Join(renders, " AND ") + "]"
}

// RenderJSON implements Condition.
func (c *andCond) RenderJSON() *json.Node {
	conditionsArray := make([]*json.Node, len(c.conditions))
	for i, condition := range c.conditions {
		conditionsArray[i] = condition.RenderJSON()
	}
	return json.ObjectNode("", map[string]*json.Node{
		"type":       json.StringNode("", "and"),
		"conditions": json.ArrayNode("", conditionsArray),
	})
}

// Eval implements Condition.
func (c *andCond) Eval(votes map[string]Vote) bool {
	for _, condition := range c.conditions {
		if !condition.Eval(votes) {
			return false
		}
	}
	return true
}

// Signal implements Condition.
func (c *andCond) Signal(votes map[string]Vote) float64 {
	minSignal := 1.0
	for _, condition := range c.conditions {
		minSignal = math.Min(minSignal, condition.Signal(votes))
	}
	return minSignal
}

// RenderJSONWithVotes implements Condition.
func (c *andCond) RenderJSONWithVotes(votes map[string]Vote) *json.Node {
	conditionsArray := make([]*json.Node, len(c.conditions))
	for i, condition := range c.conditions {
		conditionsArray[i] = condition.RenderJSONWithVotes(votes)
	}
	return json.ObjectNode("", map[string]*json.Node{
		"type":       json.StringNode("", "and"),
		"conditions": json.ArrayNode("", conditionsArray),
	})
}

var _ Condition = (*andCond)(nil)
