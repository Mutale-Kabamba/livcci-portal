@extends('reports.report_layout')

@section('title', 'LiVCCI Revenue Report')
@section('report_title', 'Revenue Report')

@section('content')
    <table class="summary">
        <thead>
            <tr>
                <th>Total Potential Revenue</th>
                <th>Total Collected</th>
                <th>Outstanding Balance (Arrears)</th>
            </tr>
        </thead>
        <tbody>
            <tr>
                <td>ZMW {{ number_format((float)($reportData['total_potential_revenue'] ?? 0), 2) }}</td>
                <td>ZMW {{ number_format((float)($reportData['total_paid'] ?? 0), 2) }}</td>
                <td>ZMW {{ number_format((float)($reportData['outstanding_balance'] ?? 0), 2) }}</td>
            </tr>
        </tbody>
    </table>

    <table>
        <thead>
            <tr>
                <th>Membership Type</th>
                <th>Invoices Paid</th>
                <th>Amount Collected</th>
            </tr>
        </thead>
        <tbody>
            @forelse(($reportData['breakdown'] ?? []) as $row)
                <tr>
                    <td>{{ $row->membership_type }}</td>
                    <td>{{ $row->invoices_count }}</td>
                    <td>ZMW {{ number_format((float)$row->total_amount, 2) }}</td>
                </tr>
            @empty
                <tr>
                    <td colspan="3">No revenue records for selected filters.</td>
                </tr>
            @endforelse
        </tbody>
    </table>
@endsection
