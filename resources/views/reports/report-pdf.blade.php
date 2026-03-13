<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>LiVCCI Report</title>
    <style>
        body { font-family: DejaVu Sans, sans-serif; font-size: 12px; color: #1f2937; }
        .header { background: #1D2A68; color: white; padding: 14px; }
        .sub { color: #6b7280; margin-bottom: 14px; }
        table { width: 100%; border-collapse: collapse; margin-top: 10px; }
        th, td { border: 1px solid #d1d5db; padding: 8px; text-align: left; vertical-align: top; }
        th { background: #1876C3; color: white; }
        .title { font-size: 18px; font-weight: bold; }
    </style>
</head>
<body>
    <div class="header">
        <div class="title">LiVCCI Report</div>
        <div>{{ strtoupper(str_replace('_', ' ', $reportType)) }}</div>
    </div>

    <p class="sub">Generated: {{ $generatedAt->format('Y-m-d H:i:s') }}</p>

    @if($reportType === 'revenue_summary')
        <p><strong>Total Paid Revenue:</strong> ZMW {{ number_format((float)($reportData['total_paid'] ?? 0), 2) }}</p>
        <table>
            <thead>
                <tr>
                    <th>Membership Type</th>
                    <th>Invoices</th>
                    <th>Amount</th>
                </tr>
            </thead>
            <tbody>
                @foreach(($reportData['breakdown'] ?? []) as $row)
                    <tr>
                        <td>{{ $row->membership_type }}</td>
                        <td>{{ $row->invoices_count }}</td>
                        <td>ZMW {{ number_format((float)$row->total_amount, 2) }}</td>
                    </tr>
                @endforeach
            </tbody>
        </table>
    @elseif($reportType === 'membership_list')
        <p><strong>Approved Members:</strong> {{ $reportData['count'] ?? 0 }}</p>
        <table>
            <thead>
                <tr>
                    <th>Company</th>
                    <th>Sector</th>
                    <th>Membership</th>
                    <th>Date Joined</th>
                </tr>
            </thead>
            <tbody>
                @foreach(($reportData['members'] ?? []) as $member)
                    <tr>
                        <td>{{ $member->company_name }}</td>
                        <td>{{ $member->industry_sector }}</td>
                        <td>{{ $member->membership_type ?? 'N/A' }}</td>
                        <td>{{ \Carbon\Carbon::parse($member->created_at)->format('Y-m-d') }}</td>
                    </tr>
                @endforeach
            </tbody>
        </table>
    @else
        <p><strong>Total Members in Analysis:</strong> {{ $reportData['total_members'] ?? 0 }}</p>
        <table>
            <thead>
                <tr>
                    <th>Industry Sector</th>
                    <th>Members</th>
                    <th>Top Activities</th>
                </tr>
            </thead>
            <tbody>
                @foreach(($reportData['sectors'] ?? []) as $sector)
                    <tr>
                        <td>{{ $sector['sector'] }}</td>
                        <td>{{ $sector['members_count'] }}</td>
                        <td>
                            @if(!empty($sector['top_activities']))
                                @foreach($sector['top_activities'] as $index => $activity)
                                    {{ $activity['activity'] }} ({{ $activity['count'] }})@if($index < count($sector['top_activities']) - 1), @endif
                                @endforeach
                            @else
                                No activities recorded
                            @endif
                        </td>
                    </tr>
                @endforeach
            </tbody>
        </table>
    @endif
</body>
</html>
