package daocond

import (
	"errors"
	"math"

	"gno.land/p/demo/json"
	"gno.land/p/demo/ufmt"
)

type membersThresholdCond struct {
	isMemberFn     func(memberId string) bool
	membersCountFn func() uint64
	threshold      float64
}

func MembersThreshold(threshold float64, isMemberFn func(memberId string) bool, membersCountFn func() uint64) Condition {
	if threshold <= 0 || threshold > 1 {
		panic(errors.New("invalid threshold"))
	}
	if isMemberFn == nil {
		panic(errors.New("nil isMemberFn"))
	}
	if membersCountFn == nil {
		panic(errors.New("nil membersCountFn"))
	}
	return &membersThresholdCond{
		threshold:      threshold,
		isMemberFn:     isMemberFn,
		membersCountFn: membersCountFn,
	}
}

// Render implements Condition.
func (c *membersThresholdCond) Render() string {
	return ufmt.Sprintf("%g%% of members", c.threshold*100)
}

// RenderJSON implements Condition.
func (c *membersThresholdCond) RenderJSON() *json.Node {
	return json.ObjectNode("", map[string]*json.Node{
		"type":      json.StringNode("", "members-threshold"),
		"threshold": json.NumberNode("", c.threshold),
	})
}

// Eval implements Condition.
func (c *membersThresholdCond) Eval(votes map[string]Vote) bool {
	return c.yesRatio(votes) >= c.threshold
}

// Signal implements Condition.
func (c *membersThresholdCond) Signal(votes map[string]Vote) float64 {
	return math.Min(c.yesRatio(votes)/c.threshold, 1)
}

// RenderJSONWithVotes implements Condition.
func (c *membersThresholdCond) RenderJSONWithVotes(votes map[string]Vote) *json.Node {
	return json.ObjectNode("", map[string]*json.Node{
		"type":         json.StringNode("", "members-threshold"),
		"threshold":    json.NumberNode("", c.threshold),
		"totalYes":     json.NumberNode("", float64(c.totalYes(votes))),
		"totalMembers": json.NumberNode("", float64(c.membersCountFn())),
		"yesRatio":     json.NumberNode("", c.yesRatio(votes)),
	})
}

var _ Condition = (*membersThresholdCond)(nil)

func (c *membersThresholdCond) yesRatio(votes map[string]Vote) float64 {
	return float64(c.totalYes(votes)) / float64(c.membersCountFn())
}

func (c *membersThresholdCond) totalYes(votes map[string]Vote) uint64 {
	totalYes := uint64(0)
	for userId, vote := range votes {
		if vote != VoteYes {
			continue
		}
		if !c.isMemberFn(userId) {
			continue
		}
		totalYes += 1
	}
	return totalYes
}
