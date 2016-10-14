--- Incorporating ILO into a Procedure

                                           p_amount             IN  NUMBER,
                                           p_status_code        OUT NUMBER,
                                           p_status_message     OUT VARCHAR2)

  status_code values
    =========== ===========================================================
         -20105 Customer ID must have a non-null value.
         -20110 Requested amount must have a non-null value.
         -20500 Credit Request Declined.
  v_authorization NUMBER;



IF ( (p_customer_id) IS NULL ) THEN 
   RAISE_APPLICATION_ERROR(-20105, 'Customer ID must have a non-null value.', TRUE);

   RAISE_APPLICATION_ERROR(-20110, 'Requested amount must have a non-null value.', TRUE);

v_authorization := round(dbms_random.value(p_customer_id, p_amount), 0);

IF ( v_authorization between 324 and 342 ) THEN 
   RAISE_APPLICATION_ERROR(-20500, 'Credit Request Declined.', TRUE);

p_authorization:= v_authorization; 
p_status_code:= 0; 
p_status_message:= NULL;

ilo_task.end_task;

EXCEPTION
  WHEN OTHERS THEN
    p_status_message:= SQLERRM;

    BEGIN
      ROLLBACK TO SAVEPOINT RequestCredit;
    END;

ilo_task.end_task(error_num => p_status_code);

END credit_request; 
/