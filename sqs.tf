resource "aws_sqs_queue" "approved_payments" {
  name                    = "approvedPayments.fifo"
  fifo_queue              = true
  sqs_managed_sse_enabled = true

  tags = {
    Name : "SOAT-TC SQS Approved Payments FIFO Queue"
  }
}
