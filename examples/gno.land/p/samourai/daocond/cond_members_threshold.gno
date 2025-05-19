package daocond

import (
	"errors"
	"math"

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

// Eval implements Condition.
func (c *membersThresholdCond) Eval(votes map[string]Vote) bool {
	return c.yesRatio(votes) >= c.threshold
}

// Signal implements Condition.
func (c *membersThresholdCond) Signal(votes map[string]Vote) float64 {
	return math.Min(c.yesRatio(votes)/c.threshold, 1)
}

// Render implements Condition.
func (c *membersThresholdCond) Render() string {
	return ufmt.Sprintf("%g%% of members", c.threshold*100)
}

// RenderWithVotes implements Condition.
func (c *membersThresholdCond) RenderWithVotes(votes map[string]Vote) string {
	s := ""
	s += ufmt.Sprintf("to meet the condition, %g%% of members must vote yes\n\n", c.threshold*100)
	s += ufmt.Sprintf("Yes: %d/%d = %g%%\n\n", c.totalYes(votes), c.membersCountFn(), c.yesRatio(votes)*100)
	return s
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
