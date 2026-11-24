
---
name: egm-kiro-workflow
description: Orchestrate the complete Elephant-Goldfish Model workflow in Kiro IDE and CLI. Use for software design, brainstorming, independent reviews, Kiro Specs, implementation and drift detection.
---

# EGM Kiro Workflow

You coordinate EGM with Kiro.

## Available original EGM skills

Use the installed upstream skills when appropriate:

- egm-brainstorm
- egm-draft
- egm-review
- egm-resolve
- egm-bootstrap
- egm-lite
- egm-review-loop
- egm-drift-report

Discover the actual installed skill names before invoking them.
Never assume an unavailable skill exists.

## Phase A - Bootstrap

For existing repositories:

1. Inspect README and source tree.
2. Identify architecture and technologies.
3. Use the original EGM bootstrap skill.
4. Review generated documentation.
5. Save the verified context.

## Phase B - Brainstorm

1. Clarify the feature.
2. Identify user needs.
3. Identify constraints.
4. Evaluate alternatives.
5. Record decisions.
6. Produce a concept brief.

Save under docs/egm/briefs/.

## Phase C - Draft

Use the original EGM draft skill.

Produce a self-contained design document.

Save under docs/designs/.

Do not implement.

## Phase D - Goldfish review

Use fresh invocations of egm-goldfish.

Run five independent reviews:

1. Requirements.
2. Architecture.
3. Security and data.
4. Operations.
5. Implementation and tests.

Each reviewer must receive only the design,
relevant source material and its review assignment.

Do not pass the Elephant conversation or prior reports.

Save each report under docs/egm/reviews/.

If independent execution is not possible, report
the limitation instead of simulating independence.

## Phase E - Resolve

Use the original EGM resolve skill.

Present findings to the user.

Distinguish:
- Accepted findings.
- Rejected findings with justification.
- Deferred findings.
- Unresolved questions.

Update the design.

Repeat review when substantial changes are made.

## Phase F - Human approval

Request explicit approval.

Do not infer approval from silence.

## Phase G - Kiro Specs

After approval:

1. Create Kiro requirements.
2. Create Kiro design.
3. Create implementation tasks.
4. Map requirements to acceptance tests.
5. Check consistency with the approved EGM document.

The approved EGM document remains the design source of truth.

## Phase H - Implementation

Implement approved Kiro tasks.

Run tests and report results.

Do not silently expand scope.

## Phase I - Drift

Use egm-drift-report to compare documentation
and implementation.

Report divergence and propose corrections.

Never change approved requirements without permission.
