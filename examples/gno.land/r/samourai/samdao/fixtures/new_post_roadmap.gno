package main

import (
	"gno.land/p/samourai/daokit"
	"gno.land/r/samourai/samdao"
)

func main() {
	daokit.InstantExecute(samdao.DAO, daokit.ProposalRequest{
		Title:       "Publish Daokit Roadmap",
		Description: "A blog post detailing the current and upcoming roadmap for Daokit.",
		Message: samdao.NewNewPostMsg(
			"daokit-roadmap",
			"Daokit Roadmap",
			`
## 🔧 Features in Progress

- ✅ **Rank Priority for Display**  
  Display members with higher ranks first (e.g., CEO above regular crew members).

- 🏠 **Homepage Display Optimization**  
  Show only the first few members on the homepage, with a link to view the full member list.

- 👤 **Username Standardization**  
  Use the r/sys/user username format for all members for consistency.

## 🔁 Cycles & Time-Based Mechanics

- ⏳ **Rank Evolution Logic**  
  Introduce automatic cycling and rank upgrades:  
  - Example: Freelance → Senior Freelance based on time or contributions  
  - CEO re-election mechanism every 4 years

## 🧾 Governance Improvements

- 🧠 **Vote Condition Rendering**  
  Improve condition readability with a JSON pretty-printing tool or viewer.

## 🌉 Resource Integration

Bridge internal Daokit data with external real-world resources:

- 🏦 **Bank** → [Qonto](https://qonto.com)  
- ☁️ **Cloud Provider** → [Scaleway](https://www.scaleway.com)  
- 💬 **Social Platforms** → Discord, YouTube, Twitter

## 📦 Ecosystem Compatibility

- 🔄 **Package Adaptation for Full Daokit Support**  
  Extend Daokit integration across key modules:  
  - payrolls  
  - project manager  
  - feeds  
  - *...and more*

---

Stay tuned for continuous updates.  
Contributions, feedback, and weird feature requests welcome. 🥷
`,
			"2025-07-01T00:00:00Z",
			[]string{"Mikael", "Fanny"},
			[]string{"Daokit"},
		),
	})
}
