# Global context: Michael Andrews

## Purpose and source

Use this background to understand who Michael is, calibrate technical depth, and tailor relevant engineering, architecture, strategy, and career work. Do not assume every project uses the technologies listed here.

Source: `/Users/Michael/Documents/Resume/Michael Andrews 2026.pdf`, supplied by Michael as his current resume. Seeded on 2026-10-18. Job titles, employment status, platform scale, and impact metrics below reflect that resume; confirm them when their current accuracy matters. This is professional background, not a substitute for task-specific requirements.

## Location

Michael lives in Ashburn, Virginia, United States.

## Professional profile

Michael Andrews (Michael A. Andrews on his resume) is a hands-on technical leader and engineer specializing in backend/platform engineering, infrastructure automation, and enterprise modernization. He combines enterprise technical strategy and leadership of large-scale, multi-year modernization efforts with hands-on architecture and implementation.

His resume describes a passion for elegant software design, deployment automation, and lightweight, malleable software using Domain-driven Design, Hexagonal Architecture, and decoupled event-driven code. His work emphasizes resiliency, security, operational consistency, developer experience, self-service, and maintainable software.

## Capital One: current role in the 2026 resume

**Sr. Distinguished Engineer - Cloud Operations & Resiliency Engineering (CORE), Capital One; 2018-current in the resume.**

Michael is the Lead Distinguished Engineer and Tech AE for OneKube, Capital One's enterprise Kubernetes platform built on Amazon EKS. He developed and led its multi-year evolution from decentralized, team-owned clusters to centrally operated clusters governed by enterprise policy. The resume reports 360+ clusters across seven lines of business, supporting thousands of applications and AI/ML workloads.

The OneKube roadmap includes:

- Phase I: CLI tooling and automated workflows that retained application-team infrastructure ownership while improving consistency, repeatability, and self-service. OPA-based container runtime governance supported over one billion policy decisions per month.
- Phase II: Centralized delivery of platform components for security, access control, and operational standards. The resume reports a 90% reduction in per-cluster operational effort and image vulnerability remediation improving from months to hours. Michael personally redesigned and implemented the OneKube CLI in Go.
- Phase III: Control-plane architecture and reconciliation for centralized cluster lifecycle and ownership, improving version currency, drift management, accountability, auditability, least-privilege access, and incident response.
- Phase IV: Namespace-as-a-Service over managed clusters, with self-service Kubernetes tenancy for application teams.

He also developed the enterprise Managed Infrastructure strategy, extending the cluster lifecycle model to foundational cloud resources and other runtimes. This work moves from manual, run-once jobs toward continuously reconciled infrastructure, hardened blueprints, and policy-enforced patterns. It covers infrastructure and application deployment lifecycles, blast-radius mitigation, disaster recovery, and workflow-scoped least-privilege roles across thousands of accounts.

His Agentic SRE strategy defines the substrate AI agents need: observable desired and actual state, auditable workflows, standardized APIs, bounded actuation paths with policy guardrails, and deterministic reconciliation loops. His work includes vendor engagement, proofs of concept, and strategy and position papers aligning senior leadership.

As a CORE senior leadership team member, he contributes to department strategy, operating models, investment priorities, AI strategy, talent calibration, performance management, architecture reviews, mentoring, and hands-on coding on critical platform initiatives.

## Previous role

**Sr. Architect and Engineering Lead - Identity Engineering, AOL; 2014-2018.**

Michael led architecture, planning, and hands-on implementation of a multi-phase Identity platform modernization: Docker containerization, Kubernetes orchestration, migration to AWS, CI/CD, automated testing, no-downtime multi-region blue/green deployments, infrastructure automation, disaster recovery, and SDLC modernization.

He developed OAuth2-secured REST APIs using Domain-driven Design and Hexagonal Architecture. He also set goals and milestones, planned sprints, designed and coded solutions, led code reviews, mentored engineers, and shaped technical direction and engineering standards. The resume is selective; it does not contain his full employment history.

## Technical background

- Languages and backend: Go, Java/Spring, REST/HTTP APIs, OAuth2, distributed systems, message-based systems, and event-driven architecture.
- Architecture and engineering: Domain-driven Design, Hexagonal Architecture, lightweight software design, platform engineering, and developer experience.
- Platforms: Kubernetes, Amazon EKS, Helm, Argo CD, OPA, Plural, Crossplane, and reconciliation-based systems.
- Cloud and operations: AWS services, IAM least-privilege, cloud governance, infrastructure automation, CI/CD, DevOps, SRE, deployment automation, blue/green deployments, and business continuity and disaster recovery (BCDR).

## Writing

The resume lists these articles:

- Deconstructing The Singleton
- File Name Hashing: Creating a Hashed Directory Structure

## Local development configuration

Michael's development configuration is maintained in `~/src/dotfiles`. Shared agent instructions and skills live in its `agents/` directory, exposed through `~/.agents`.

When assisting with intentional Homebrew tool, cask, or font additions and removals, maintain the repository's `Brewfile` in the same task. Use the `maintain-dotfiles` skill for this workflow and for changes to the shell, installer, shared agent configuration, or iTerm2 preferences.
