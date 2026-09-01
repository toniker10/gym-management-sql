# Gym Management SQL Project

A small relational database for a gym: trainers, members, memberships, classes and class registrations, plus a set of queries covering joins, aggregation, window functions, CTEs, a view, and a transaction.

## Schema

- **trainers** — trainer info and specialty
- **members** — member info, unique email, join date
- **memberships** — plan type, price, start/end date, tied to a member
- **classes** — class name, date, time, trainer, capacity
- **class_registrations** — who signed up for which class and when

Relationships: `memberships`, `classes` and `class_registrations` all reference `members`/`trainers`/`classes` through foreign keys, with `ON DELETE CASCADE` / `ON DELETE SET NULL` so the data stays consistent if a member or trainer is removed.

## What's in `gym_management.sql`

1. Schema (`DROP` + `CREATE TABLE`) with constraints (`NOT NULL`, `UNIQUE`, `CHECK`, foreign keys with delete rules)
2. Indexes on the columns used most in `JOIN`/`WHERE`
3. Sample data (`INSERT`)
4. Queries 1–7: basic joins, aggregation, `LEFT JOIN` for "members with nothing"
5. Query 8: `CASE` statement to tag members by spend tier
6. Query 9: `RANK() OVER (...)` window function to rank trainers by class count
7. Query 10: CTE (`WITH`) to find members above the average number of class registrations
8. A `VIEW` (`active_members_view`) for memberships that are still valid, plus query 11 using it
9. A `BEGIN` / `COMMIT` transaction example: adding a member and registering them for a class as one atomic operation

## How to run it

```bash
psql -U your_user -d your_database -f gym_management.sql
```

(or the MySQL/SQLite equivalent — the syntax used here is standard SQL, just double check `CONCAT`, `RANK()` and `CURRENT_DATE` are supported by your engine)

## Notes

- Dates use the `DATE` type instead of `VARCHAR`, so date comparisons and sorting actually work correctly.
- `active_members_view` filters on `CURRENT_DATE`, so results will differ depending on when you run it — that's intentional, it's meant to reflect "who's active right now."
