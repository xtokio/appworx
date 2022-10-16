BEGIN TRANSACTION;

CREATE TABLE IF NOT EXISTS "users" (
  "id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
  "username"	  TEXT NOT NULL,
  "password"	  TEXT NOT NULL,
  "name"	  TEXT NOT NULL DEFAULT '',
  "account_type"  TEXT NOT NULL,
  "active"	  INTEGER NOT NULL DEFAULT 1,
  "created_at"	  TEXT NOT NULL DEFAULT '',
  "updated_at"	  TEXT NOT NULL DEFAULT ''
);
CREATE TABLE IF NOT EXISTS "jobs" (
  "id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
  "user_id"	  INTEGER NOT NULL DEFAULT 1,
  "job"		  TEXT NOT NULL DEFAULT '',
  "description"	  TEXT NOT NULL,
  "schedule"	  TEXT NOT NULL,
  "schedule_time" TEXT NOT NULL,
  "active"	  INTEGER NOT NULL DEFAULT 1,
  "created_at"	  TEXT NOT NULL DEFAULT '',
  "updated_at"	  TEXT NOT NULL DEFAULT ''
);
CREATE TABLE IF NOT EXISTS "tasks" (
  "id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
  "job_id"	INTEGER NOT NULL DEFAULT 1,
  "task"	TEXT NOT NULL DEFAULT '',
  "description"	TEXT NOT NULL DEFAULT '',
  "language"	TEXT NOT NULL DEFAULT '',
  "command"	TEXT NOT NULL DEFAULT '',
  "active"	INTEGER NOT NULL DEFAULT 1,
  "created_at"	TEXT NOT NULL DEFAULT '',
  "updated_at"	TEXT NOT NULL DEFAULT ''
);
CREATE TABLE IF NOT EXISTS "task_status" (
  "id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
  "job_id"	INTEGER NOT NULL,
  "task_id"	INTEGER NOT NULL,
  "status"	INTEGER NOT NULL DEFAULT 0,
  "response"	TEXT NOT NULL DEFAULT '',
  "created_at"	TEXT NOT NULL DEFAULT '',
  "updated_at"	TEXT NOT NULL DEFAULT ''
);

CREATE VIEW view_tasks AS
SELECT tasks.id,tasks.job_id,jobs.job,tasks.task,tasks.description,tasks.language,tasks.command,tasks.active,tasks.created_at,tasks.updated_at
FROM tasks,jobs
WHERE tasks.job_id = jobs.id;

COMMIT;
