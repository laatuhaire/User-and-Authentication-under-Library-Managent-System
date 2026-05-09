# 🔐 User & Authentication System
### Library Management System — Mbarara University of Science and Technology

> A secure, role-based authentication and access control module built with MySQL, designed to govern digital identity, session tracking, and permission enforcement across a university library platform.

---

## 📋 Table of Contents

- [Overview](#overview)
- [Features](#features)
- [Database Schema](#database-schema)
- [Roles & Permissions](#roles--permissions)
- [Authentication Flow](#authentication-flow)
- [Tables Reference](#tables-reference)
- [Sample Data](#sample-data)
- [Security Design](#security-design)
- [System Limitations](#system-limitations)
- [Project Info](#project-info)

---

## Overview

This module is the **User and Authentication subsystem** of a broader Library Management System. It handles everything related to who can access the system, what they are allowed to do, and how their sessions are tracked and secured.

The system resolves five core concerns:

| Concern | Description |
|---|---|
| **Login Management** | Secure credential validation at runtime |
| **User Identification** | Dynamic identity matching across member and staff tables |
| **Role-Based Access** | Restricts operations based on assigned user roles |
| **Session Tracking** | Maintains and monitors active login state |
| **Data Security** | Protects sensitive records from unauthorized access |

---

## Features

- ✅ Role-Based Access Control (RBAC) with a dedicated `Roles` and `RolePermissions` junction table
- ✅ Separate `Members` and `Staff` tables with shared role infrastructure
- ✅ High-entropy session tokens with expiry and revocation support
- ✅ Login attempt logging with lockout tracking (`LoginAttempts`, `AccountLockouts`)
- ✅ Secure password reset flow via hashed, expiring tokens (`PasswordResets`)
- ✅ Email verification system (`EmailVerifications`)
- ✅ Full audit trail via `AuditLog` table
- ✅ Salt-based password hashing (bcrypt-ready schema)
- ✅ IP address and user-agent tracking per session

---

## Database Schema

The system is built on **MySQL / MariaDB** and consists of **11 interlinked tables**:

```
library_auth
│
├── Roles                  # Permission categories (superadmin, librarian, student, guest)
├── Members                # Student/public library member accounts
├── Staff                  # Librarian and admin staff accounts
├── Permissions            # Granular action permissions per module
├── RolePermissions        # Junction table: maps roles to permissions
├── Sessions               # Active session tokens per actor
├── LoginAttempts          # Full login history (success / failed / locked)
├── AccountLockouts        # Lockout records with unlock timestamps
├── PasswordResets         # Secure, expiring reset tokens
├── EmailVerifications     # Email confirmation tokens
└── AuditLog               # System-wide action audit trail
```

---

## Roles & Permissions

Four roles are defined within the system:

| Role | Access Level | Description |
|---|---|---|
| `superadmin` | Full system access | Manages all users, roles, and configurations |
| `librarian` | Operational access | Handles circulation, member management |
| `student` | Self-service access | Searches catalogue, views borrow history |
| `guest` | Read-only access | Walk-in users with minimal privileges |

Permissions are modular and assigned per role via the `RolePermissions` junction table, allowing fine-grained control per system module (e.g., `books`, `loans`, `users`).

---

## Authentication Flow

```
[Login Screen]
      │
      ▼ Input Email & Password
[Database Engine Check]
      │
      ├── ❌ Invalid Credentials → Alert & Retry (attempt logged)
      │         │
      │         └── ≥ 5 failures → AccountLockout created
      │
      └── ✅ Valid Match
                │
                ▼ Validate Role → Generate Session Token
                │
                ├── superadmin  → Admin Control Panel
                ├── librarian   → Circulation Management Desk
                ├── student     → Self-Service Book Finder
                └── guest       → Read-Only Catalogue View
```

---

## Tables Reference

### `Roles`
| Column | Type | Description |
|---|---|---|
| `role_id` | INT PK | Auto-incremented role identifier |
| `role_name` | VARCHAR(30) UNIQUE | Human-readable role label |
| `description` | TEXT | Role purpose description |

### `Members`
| Column | Type | Description |
|---|---|---|
| `member_id` | INT PK | Unique member identifier |
| `username` | VARCHAR(50) UNIQUE | Login username |
| `email` | VARCHAR(100) UNIQUE | University email address |
| `password_hash` | VARCHAR(255) | Hashed credential |
| `salt` | VARCHAR(64) | Per-user password salt |
| `role_id` | INT FK | Linked security role |
| `membership_no` | VARCHAR(20) UNIQUE | Physical library card number |
| `university_id` | VARCHAR(50) | e.g. `2025/BCS/055` |
| `max_books_allowed` | INT | Borrowing cap (default: 3) |
| `status` | ENUM | `Active` / `Suspended` / `Expired` |
| `is_email_verified` | TINYINT | Email confirmation flag |

### `Sessions`
| Column | Type | Description |
|---|---|---|
| `session_id` | VARCHAR(128) PK | High-entropy session token |
| `actor_id` | INT | Linked member or staff ID |
| `actor_type` | ENUM | `member` or `staff` |
| `ip_address` | VARCHAR(45) | Client IP |
| `user_agent` | VARCHAR(255) | Browser/client signature |
| `created_at` | TIMESTAMP | Session start time |
| `expires_at` | DATETIME | Session expiry window |
| `is_revoked` | TINYINT | Manual revocation toggle |

### `AuditLog`
| Column | Type | Description |
|---|---|---|
| `log_id` | BIGINT PK | Auto-incremented log entry |
| `actor_id` | INT | User who performed the action |
| `actor_type` | ENUM | `member` or `staff` |
| `action` | VARCHAR(100) | Action performed |
| `table_affected` | VARCHAR(100) | Target database table |
| `details` | TEXT | Full action context |
| `timestamp` | TIMESTAMP | Exact time of event |

---

## Sample Data

Five members are seeded for testing purposes:

| Name | Email | Role | Membership No | Status |
|---|---|---|---|---|
| Aisha Mukwatanzi | 2025bcs055@std.must.ac.ug | student | MUST-STD-055 | Active |
| Brian Ssentamu | 2025bit032@std.must.ac.ug | student | MUST-STD-032 | Active |
| Catherine Mugisha | 2024bse019@std.must.ac.ug | student | MUST-STD-019 | Active |
| Ronald Opolot | 2025bcv041@std.must.ac.ug | student | MUST-STD-041 | Active |
| Walk-in Guest | guest@library.must.ac.ug | guest | MUST-GST-001 | Active |

> **Note:** All `password_hash` values in seed data are placeholders. Production deployment must use bcrypt-hashed values.

---

## Security Design

| Mechanism | Implementation |
|---|---|
| Password Storage | Salted hash per user (bcrypt-ready) |
| Session Security | High-entropy VARCHAR(128) token, IP-bound |
| Brute Force Protection | `LoginAttempts` table + `AccountLockouts` |
| Privilege Escalation Prevention | Role assignments validated at DB engine level |
| Audit Trail | All actions logged to `AuditLog` with timestamps |
| Token Expiry | All reset and verification tokens have `expires_at` |
| Email Verification | Required flag `is_email_verified` on both `Members` and `Staff` |

---

## System Limitations

- **Credential Sharing:** The database cannot prevent users from voluntarily sharing active login tokens.
- **Policy Dependence:** Security effectiveness relies on users following password guidelines.
- **Scope Boundary:** This module manages logical database access only — it does not control physical security gates or RFID book-tracking hardware.
- **Emerging Threats:** Continuous monitoring is required as new attack vectors evolve.

---

## Project Info

| Field | Detail |
|---|---|
| **Student** | Atuhaire Lucky Abigail |
| **Registration No.** | 2025/BCS/055/PS |
| **Program** | Bachelor of Computer Science, Year 1 |
| **Institution** | Mbarara University of Science and Technology |
| **Department** | Computer Science — Faculty of Computing and Informatics |
| **Course Instructor** | Mr. Kenneth Baguma |
| **Submission Date** | May 7, 2026 |
| **Database Engine** | MySQL / MariaDB (via XAMPP) |
| **Area of Interest** | Library Management System |

---

*This system was developed as part of the Database Management Systems practical assignment. All design, implementation, and documentation is original work.*
