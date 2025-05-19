package daocond

import (
	"gno.land/p/demo/json"
)

// We made conditions stateless to avoid complexity of handling events like (member added, member removed, role assigned, role removed, etc.)
// This model should work pretty good for small DAOs with few voters.
// In future, we should probably add a stateful model for large DAOs with many voters.

type Condition interface {
	Eval(votes map[string]Vote) bool
	Signal(votes map[string]Vote) float64

	Render() string
	RenderWithVotes(votes map[string]Vote) string
}

type ConditionJSONEncoder interface {
	RenderJSON() *json.Node
	RenderJSONWithVotes(votes map[string]Vote) *json.Node
}

type Vote string

const (
	VoteYes     = "yes"
	VoteNo      = "no"
	VoteAbstain = "abstain"
)
