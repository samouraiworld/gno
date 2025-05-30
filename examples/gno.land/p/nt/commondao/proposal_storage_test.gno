package commondao

import (
	"testing"

	"gno.land/p/demo/uassert"
	"gno.land/p/demo/urequire"
)

func TestProposalStorageAdd(t *testing.T) {
	p, _ := NewProposal(1, "g1jg8mtutu9khhfwc4nxmuhcpftf0pajdhfvsqf5", testPropDef{})
	s := NewProposalStorage()
	initialSize := s.Size()

	s.Add(p)

	uassert.Equal(t, 0, initialSize, "expect initial storage to be empty")
	uassert.Equal(t, 1, s.Size(), "expect storage to have one proposal")
	uassert.True(t, s.Has(p.ID()), "expect proposal to be found")
}

func TestProposalStorageGet(t *testing.T) {
	p, _ := NewProposal(1, "g1jg8mtutu9khhfwc4nxmuhcpftf0pajdhfvsqf5", testPropDef{})
	s := NewProposalStorage()
	s.Add(p)

	p2 := s.Get(p.ID())

	urequire.NotEqual(t, nil, p2, "expect proposal to be found")
	uassert.Equal(t, p.ID(), p2.ID(), "expect proposal ID to match")
}

func TestProposalStorageRemove(t *testing.T) {
	p, _ := NewProposal(1, "g1jg8mtutu9khhfwc4nxmuhcpftf0pajdhfvsqf5", testPropDef{})
	s := NewProposalStorage()
	s.Add(p)

	s.Remove(p.ID())

	uassert.Equal(t, 0, s.Size(), "expect storage to be empty")
	uassert.False(t, s.Has(p.ID()), "expect proposal to be not found")
}

func TestProposalStorageIterate(t *testing.T) {
	var (
		i   int
		ids = []uint64{22, 33, 44}
		s   = NewProposalStorage()
	)

	for _, id := range ids {
		p, _ := NewProposal(id, "g1jg8mtutu9khhfwc4nxmuhcpftf0pajdhfvsqf5", testPropDef{})
		s.Add(p)
	}

	s.Iterate(0, s.Size(), func(p *Proposal) bool {
		uassert.Equal(t, ids[i], p.ID(), "expect proposal ID to match")

		i++
		return i == s.Size()
	})

	uassert.Equal(t, len(ids), i, "expect storage to iterate all proposals")
}
