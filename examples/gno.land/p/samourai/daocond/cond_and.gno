package daocond

import (
	"strings"
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
	totalSignal := 0.0
	for _, condition := range c.conditions {
		totalSignal += condition.Signal(votes)
	}
	return totalSignal / float64(len(c.conditions))
}

// Render implements Condition.
func (c *andCond) Render() string {
	renders := []string{}
	for _, condition := range c.conditions {
		renders = append(renders, condition.Render())
	}
	return "[" + strings.Join(renders, " AND ") + "]"
}

// RenderWithVotes implements Condition.
func (c *andCond) RenderWithVotes(votes map[string]Vote) string {
	renders := []string{}
	for _, condition := range c.conditions {
		renders = append(renders, condition.RenderWithVotes(votes))
	}
	return "[" + strings.Join(renders, " AND ") + "]"
}

var _ Condition = (*andCond)(nil)
