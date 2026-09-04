-- Add CANCEL transaction type for gold bill cancellation ledger reversals
ALTER TABLE `gold_ledger`
  MODIFY COLUMN `txn_type` ENUM('BILL','PAYMENT','OPENING','CANCEL') NOT NULL DEFAULT 'BILL';
