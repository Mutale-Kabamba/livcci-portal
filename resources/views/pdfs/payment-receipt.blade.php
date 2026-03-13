<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>LiVCCI Payment Receipt</title>
    <style>
        body { font-family: DejaVu Sans, Arial, sans-serif; color: #1f2937; margin: 0; padding: 24px; }
        .card { border: 1px solid #e5e7eb; }
        .head { background: #1D2A68; color: #fff; padding: 16px 20px; font-weight: 800; font-size: 20px; }
        .body { padding: 16px 20px; }
        .row { margin: 6px 0; font-size: 13px; }
        .value { font-weight: 700; color: #111827; }
    </style>
</head>
<body>
    <div class="card">
        <div class="head">Payment Receipt</div>
        <div class="body">
            <div class="row"><span class="value">Company:</span> {{ $profile->company_name }}</div>
            <div class="row"><span class="value">Date:</span> {{ \Illuminate\Support\Carbon::parse($payment->payment_date)->format('F d, Y') }}</div>
            <div class="row"><span class="value">Method:</span> {{ $payment->payment_method }}</div>
            <div class="row"><span class="value">Reference:</span> {{ $payment->reference ?: '-' }}</div>
            <div class="row"><span class="value">Amount:</span> ZMW {{ number_format((float)$payment->amount, 2) }}</div>
        </div>
    </div>
</body>
</html>
