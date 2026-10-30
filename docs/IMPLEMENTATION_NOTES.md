# Implementation Notes

## 1. Records and Collections Design
- User-Defined Records: Used within the batch registration procedure to cleanly bundle composite fields (`student_id` and `standing`) fetched from multi-table join criteria.
- %ROWTYPE Records: Utilized in functions like 'calculate_gpa' to capture entire row structures dynamically, insulating code against future schema modifications (e.g., adding columns to the student table).
- Nested Tables: Employed alongside 'BULK COLLECT' to hold intermediate result sets in memory efficiently.

## 2. Cursors and Bulk Processing Performance
- BULK COLLECT & FORALL: Instead of processing rows in a slow row-by-row FOR loop (which causes excessive context switching between the PL/SQL engine and SQL execution engine), BULK COLLECT retrieves collections in batches, and FORALL executes DML inserts in a single context switch.
- SAVE EXCEPTIONS clause: Integrated into the 'FORALL' statement to ensure that if a subset of row insertions fail due to unique key violations or check constraints, valid rows still successfully commit while errors are caught and logged cleanly.

## 3. Exception Handling Strategy
- Predefined exceptions like 'NO_DATA_FOUND' and custom application errors ('RAISE_APPLICATION_ERROR' with codes '-20001' through '-20006') provide clear, user-friendly error strings back to calling applications instead of unhandled exceptions.
