
# Elephant-Goldfish Model - Project Rules

## General policy

This project follows Spec-Driven Development using EGM
and Kiro Specs.

The workflow applies to Kiro IDE and Kiro CLI.

## Mandatory workflow

For substantial features:

1. Inspect project context.
2. Clarify requirements.
3. Create a concept brief.
4. Draft a technical specification.
5. Perform independent Goldfish reviews.
6. Resolve review findings.
7. Obtain explicit human approval.
8. Create or update Kiro Specs.
9. Implement approved tasks.
10. Run tests and verify acceptance criteria.
11. Report specification/code drift.

## Artifact locations

- Concepts: docs/egm/briefs/
- Design documents: docs/designs/
- Review reports: docs/egm/reviews/
- Approved specifications: docs/designs/approved/
- Kiro Specs: .kiro/specs/

## Design rules

- Do not invent requirements.
- Separate assumptions from verified facts.
- Record architectural decisions.
- Make requirements testable.
- Define acceptance criteria.
- Document dependencies and risks.
- Preserve traceability between requirements,
  design decisions, tasks and tests.

## Goldfish independence

Goldfish must work from a fresh subagent context.

Each reviewer receives:
- The design document.
- Relevant source files.
- Explicit review scope.
- Relevant project standards.

Each reviewer must not receive:
- Elephant's original conversation.
- Private brainstorming notes.
- Previous reviewers' conclusions.
- Suggested answers or expected findings.

Use five separate reviewer invocations when performing
a full review:

1. Requirements and completeness.
2. Architecture and consistency.
3. Security and data integrity.
4. Operations, reliability and performance.
5. Implementation and testing.

If independent subagent execution is unavailable,
do not claim that a Goldfish review was performed.

## Approval policy

Human approval is mandatory before implementation.

A review report is not an approval.

A generated Kiro Spec is not an approval.

Do not automatically close critical findings.

## Implementation policy

- Implement one approved task at a time.
- Respect project conventions.
- Add regression tests.
- Run relevant tests after each change.
- Update documentation when behavior changes.
- Do not silently change approved architecture.

## Completion report

Every implementation must report:

- Implemented requirements.
- Changed files.
- Tests executed.
- Test results.
- Known limitations.
- Remaining review findings.
- Design/code drift.
