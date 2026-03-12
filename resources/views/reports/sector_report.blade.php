@extends('reports.report_layout')

@section('title', 'LiVCCI Sector Report')
@section('report_title', 'Sector Report')

@section('content')
    <table>
        <thead>
            <tr>
                <th>Company</th>
                <th>Industry Sector</th>
                <th>Business Activities</th>
            </tr>
        </thead>
        <tbody>
            @forelse(($reportData['companies'] ?? []) as $row)
                <tr>
                    <td>{{ $row['company_name'] }}</td>
                    <td>{{ $row['industry_sector'] }}</td>
                    <td>{{ $row['business_activities'] !== '' ? $row['business_activities'] : 'No activities recorded' }}</td>
                </tr>
            @empty
                <tr>
                    <td colspan="3">No sector records for selected filters.</td>
                </tr>
            @endforelse
        </tbody>
    </table>
@endsection
