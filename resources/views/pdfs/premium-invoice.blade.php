<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>LiVCCI Premium Invoice</title>
    <style>
        body { font-family: DejaVu Sans, Arial, sans-serif; color: #1f2937; margin: 0; padding: 28px; }
        .invoice { border: 1px solid #e5e7eb; }
        .header { background: #1D2A68; color: #fff; padding: 18px 22px; }
        .brand { display: table; width: 100%; }
        .brand-cell { display: table-cell; vertical-align: middle; }
        .brand-right { text-align: right; }
        .title { font-size: 22px; font-weight: 800; margin: 0; }
        .subtitle { margin: 4px 0 0 0; color: #dbeafe; font-size: 12px; }
        .body { padding: 20px 22px; }
        .pill { display: inline-block; background: #F4B223; color: #1D2A68; font-weight: 800; font-size: 11px; padding: 4px 10px; border-radius: 999px; }
        .meta { margin-top: 10px; font-size: 13px; }
        .meta strong { color: #111827; }
        table { width: 100%; border-collapse: collapse; margin-top: 16px; }
        th, td { border: 1px solid #d1d5db; padding: 10px; font-size: 13px; }
        th { background: #f3f4f6; text-align: left; }
        .amount { font-weight: 700; color: #1D2A68; }
        .note { margin-top: 16px; padding: 12px; background: #fffbeb; border: 1px solid #f59e0b; color: #92400e; font-size: 12px; }
        .bank { margin-top: 18px; border: 1px solid #e5e7eb; padding: 12px; background: #f9fafb; }
        .bank h4 { margin: 0 0 8px 0; color: #1D2A68; }
    </style>
</head>
<body>
    <div class="invoice">
        <div class="header">
            <div class="brand">
                <div class="brand-cell">
                    @php $logo = public_path('images/logo-white.png'); @endphp
                    @if(file_exists($logo))
                        <img src="{{ $logo }}" alt="LiVCCI" style="height:42px; width:auto;">
                    @endif
                </div>
                <div class="brand-cell brand-right">
                    <p class="title">Premium Invoice</p>
                    <p class="subtitle">Livingstone Chamber of Commerce & Industry</p>
                </div>
            </div>
        </div>

        <div class="body">
            <span class="pill">Invoice #{{ $invoiceNumber }}</span>
            <div class="meta">
                <p><strong>Date:</strong> {{ \Illuminate\Support\Carbon::parse($invoiceDate)->format('F d, Y') }}</p>
                <p><strong>Billed To:</strong> {{ $profile->company_name }}</p>
                <p><strong>Membership Category:</strong> {{ $profile->member_category ?? 'General' }}</p>
            </div>

            <table>
                <thead>
                    <tr>
                        <th>Description</th>
                        <th>Amount</th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td>Annual Membership Fee</td>
                        <td class="amount">ZMW {{ number_format((float)$annualFee, 2) }}</td>
                    </tr>
                    <tr>
                        <td>Minimum to Activate (50%)</td>
                        <td class="amount">ZMW {{ number_format((float)$minimumToActivate, 2) }}</td>
                    </tr>
                </tbody>
            </table>

            <div class="note">
                Your profile becomes publicly visible in the member directory once minimum activation payment (50%) is reached.
            </div>

            <div class="bank">
                <h4>Bank Details for Payment</h4>
                <p style="margin:2px 0;"><strong>Bank:</strong> Zanaco Bank</p>
                <p style="margin:2px 0;"><strong>Account Name:</strong> Livingstone Chamber of Commerce and Industry</p>
                <p style="margin:2px 0;"><strong>Account Number:</strong> 1234567890</p>
                <p style="margin:2px 0;"><strong>Branch:</strong> Livingstone Main Branch</p>
            </div>
        </div>
    </div>
</body>
</html>
