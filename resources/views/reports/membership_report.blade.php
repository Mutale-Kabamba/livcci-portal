@extends('reports.report_layout')

@section('title', 'LiVCCI Membership Report')
@section('report_title', 'Membership Directory Report')

@section('content')
    <table>
        <thead>
            <tr>
                <th>Company</th>
                <th>Industry Sector</th>
                <th>Membership Type</th>
                <th>Date Joined</th>
            </tr>
        </thead>
        <tbody>
            @forelse(($reportData['members'] ?? []) as $member)
                <tr>
                    <td>{{ $member->company_name }}</td>
                    <td>{{ $member->industry_sector }}</td>
                    <td>{{ $member->membership_type ?? 'N/A' }}</td>
                    <td>{{ \Carbon\Carbon::parse($member->created_at)->format('Y-m-d') }}</td>
                </tr>
            @empty
                <tr>
                    <td colspan="4">No approved members for selected filters.</td>
                </tr>
            @endforelse
        </tbody>
    </table>
@endsection
