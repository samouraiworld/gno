package daocond

import (
	"math"
	"strings"

	"gno.land/p/demo/json"
)

type orCond struct {
	conditions []Condition
}

func Or(conditions ...Condition) Condition {
	if len(conditions) < 2 {
		panic("at least two conditions are required")
	}
	return &orCond{conditions: conditions}
}

// Eval implements Condition.
func (c *orCond) Eval(votes map[string]Vote) bool {
	for _, condition := range c.conditions {
		if condition.Eval(votes) {
			return true
		}
	}
	return false
}

// Signal implements Condition.
func (c *orCond) Signal(votes map[string]Vote) float64 {
	maxSignal := 0.0
	for _, condition := range c.conditions {
		maxSignal = math.Max(maxSignal, condition.Signal(votes))
	}
	return maxSignal
}

// Render implements Condition.
func (c *orCond) Render() string {
	renders := []string{}
	for _, condition := range c.conditions {
		renders = append(renders, condition.Render())
	}
	return "[" + strings.Join(renders, " OR ") + "]"
}

// RenderWithVotes implements Condition.
func (c *orCond) RenderWithVotes(votes map[string]Vote) string {
	renders := []string{}
	for _, condition := range c.conditions {
		renders = append(renders, condition.RenderWithVotes(votes))
	}
	return "[" + strings.Join(renders, " OR ") + "]"
}

// RenderJSON implements ConditionJSONEncoder.
func (c *orCond) RenderJSON() *json.Node {
	conditionsArray := make([]*json.Node, len(c.conditions))
	for i, condition := range c.conditions {
		conditionsArray[i] = condition.RenderJSON()
	}
	return json.ObjectNode("", map[string]*json.Node{
		"type":       json.StringNode("", "or"),
		"conditions": json.ArrayNode("", conditionsArray),
	})
}

// RenderJSONWithVotes implements ConditionJSONEncoder.
func (c *orCond) RenderJSONWithVotes(votes map[string]Vote) *json.Node {
	conditionsArray := make([]*json.Node, len(c.conditions))
	for i, condition := range c.conditions {
		conditionsArray[i] = condition.RenderJSONWithVotes(votes)
	}
	return json.ObjectNode("", map[string]*json.Node{
		"type":       json.StringNode("", "or"),
		"conditions": json.ArrayNode("", conditionsArray),
	})
}

var _ Condition = (*orCond)(nil)
