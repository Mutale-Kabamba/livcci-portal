<?php

namespace App\Http\Controllers;

use App\Models\BusinessProfile;
use App\Models\Invoice;
use Illuminate\Http\Request;
use Inertia\Inertia;
use Inertia\Response;

class ReportController extends Controller
{
    public function index(): Response
    {
        return Inertia::render('Admin/ReportsCenter', [
            'reportType' => null,
            'filters' => [
                'sector' => null,
                'start_date' => null,
                'end_date' => null,
                'member_type' => null,
            ],
            'reportData' => null,
        ]);
    }

    public function generate(Request $request): Response
    {
        $validated = $request->validate([
            'report_type' => 'required|in:membership_list,revenue_summary,sector_analysis',
            'filters' => 'nullable|array',
            'filters.sector' => 'nullable|string|max:255',
            'filters.start_date' => 'nullable|date',
            'filters.end_date' => 'nullable|date|after_or_equal:filters.start_date',
            'filters.member_type' => 'nullable|string|max:255',
        ]);

        $filters = $validated['filters'] ?? [];
        $reportType = $validated['report_type'];

        $reportData = match ($reportType) {
            'revenue_summary' => $this->buildRevenueSummary($filters),
            'membership_list' => $this->buildMembershipList($filters),
            'sector_analysis' => $this->buildSectorAnalysis($filters),
        };

        return Inertia::render('Admin/ReportsCenter', [
            'reportType' => $reportType,
            'filters' => [
                'sector' => $filters['sector'] ?? null,
                'start_date' => $filters['start_date'] ?? null,
                'end_date' => $filters['end_date'] ?? null,
                'member_type' => $filters['member_type'] ?? null,
            ],
            'reportData' => $reportData,
        ]);
    }

    private function buildRevenueSummary(array $filters): array
    {
        $query = Invoice::query()
            ->join('business_profiles', 'invoices.profile_id', '=', 'business_profiles.id')
            ->where('invoices.status', 'Paid');

        $this->applyInvoiceFilters($query, $filters);

        $totalPaid = (float) (clone $query)->sum('invoices.amount');

        $byMembershipType = (clone $query)
            ->selectRaw("COALESCE(business_profiles.membership_type, 'Unknown') as membership_type")
            ->selectRaw('SUM(invoices.amount) as total_amount')
            ->selectRaw('COUNT(invoices.id) as invoices_count')
            ->groupBy('business_profiles.membership_type')
            ->orderByDesc('total_amount')
            ->get();

        return [
            'total_paid' => $totalPaid,
            'breakdown' => $byMembershipType,
        ];
    }

    private function buildMembershipList(array $filters): array
    {
        $query = BusinessProfile::query()->where('status', 'approved');

        $this->applyMemberFilters($query, $filters);

        $members = $query
            ->orderBy('company_name')
            ->get([
                'id',
                'company_name',
                'contact_email',
                'industry_sector',
                'membership_type',
                'created_at',
            ]);

        return [
            'count' => $members->count(),
            'members' => $members,
        ];
    }

    private function buildSectorAnalysis(array $filters): array
    {
        $query = BusinessProfile::query()->where('status', 'approved');

        $this->applyMemberFilters($query, $filters);

        $members = $query->get(['industry_sector', 'business_activities']);

        $rows = $members
            ->groupBy(function (BusinessProfile $profile) {
                return $profile->industry_sector ?: 'Unspecified';
            })
            ->map(function ($sectorMembers, $sector) {
                $activityCounts = [];

                foreach ($sectorMembers as $member) {
                    $activities = $this->normalizeActivities($member->business_activities);
                    foreach ($activities as $activity) {
                        $activityCounts[$activity] = ($activityCounts[$activity] ?? 0) + 1;
                    }
                }

                arsort($activityCounts);

                $topActivities = collect($activityCounts)
                    ->take(5)
                    ->map(function ($count, $activity) {
                        return [
                            'activity' => $activity,
                            'count' => $count,
                        ];
                    })
                    ->values();

                return [
                    'sector' => $sector,
                    'members_count' => $sectorMembers->count(),
                    'top_activities' => $topActivities,
                ];
            })
            ->sortByDesc('members_count')
            ->values();

        return [
            'total_members' => $members->count(),
            'sectors' => $rows,
        ];
    }

    private function applyInvoiceFilters($query, array $filters): void
    {
        if (!empty($filters['start_date'])) {
            $query->whereDate('invoices.created_at', '>=', $filters['start_date']);
        }

        if (!empty($filters['end_date'])) {
            $query->whereDate('invoices.created_at', '<=', $filters['end_date']);
        }

        if (!empty($filters['sector'])) {
            $query->where('business_profiles.industry_sector', $filters['sector']);
        }

        if (!empty($filters['member_type'])) {
            $query->where(function ($inner) use ($filters) {
                $inner->where('business_profiles.membership_type', $filters['member_type'])
                    ->orWhere('business_profiles.member_type', $filters['member_type']);
            });
        }
    }

    private function applyMemberFilters($query, array $filters): void
    {
        if (!empty($filters['sector'])) {
            $query->where('industry_sector', $filters['sector']);
        }

        if (!empty($filters['start_date'])) {
            $query->whereDate('created_at', '>=', $filters['start_date']);
        }

        if (!empty($filters['end_date'])) {
            $query->whereDate('created_at', '<=', $filters['end_date']);
        }

        if (!empty($filters['member_type'])) {
            $query->where(function ($inner) use ($filters) {
                $inner->where('membership_type', $filters['member_type'])
                    ->orWhere('member_type', $filters['member_type']);
            });
        }
    }

    private function normalizeActivities($raw): array
    {
        if (is_array($raw)) {
            return array_values(array_filter(array_map('trim', $raw), function ($item) {
                return $item !== '';
            }));
        }

        if (is_string($raw) && $raw !== '') {
            $decoded = json_decode($raw, true);
            if (json_last_error() === JSON_ERROR_NONE && is_array($decoded)) {
                return array_values(array_filter(array_map('trim', $decoded), function ($item) {
                    return $item !== '';
                }));
            }

            return array_values(array_filter(array_map('trim', explode(',', $raw)), function ($item) {
                return $item !== '';
            }));
        }

        return [];
    }
}
