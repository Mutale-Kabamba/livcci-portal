<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>LiVCCI Updates</title>
</head>
<body style="margin:0;padding:0;background:#f3f4f6;font-family:Arial,sans-serif;color:#111827;">
<table role="presentation" width="100%" cellspacing="0" cellpadding="0" style="padding:24px 0;">
<tr><td align="center">
<table role="presentation" width="640" cellspacing="0" cellpadding="0" style="max-width:640px;background:#ffffff;border:1px solid #e5e7eb;border-radius:10px;overflow:hidden;">
<tr><td style="background:#1D2A68;padding:20px 24px;"><h1 style="margin:0;color:#ffffff;font-size:24px;">News & Events Updates</h1></td></tr>
<tr><td style="padding:24px;">
<p style="margin:0 0 16px 0;font-size:15px;line-height:1.6;">Here are the latest updates from LiVCCI:</p>
@foreach($events as $event)
<div style="margin:0 0 14px 0;padding:12px;border:1px solid #e5e7eb;border-radius:8px;background:#f9fafb;">
    <p style="margin:0 0 6px 0;font-size:15px;font-weight:700;color:#1D2A68;">{{ $event['title'] ?? 'Update' }}</p>
    <p style="margin:0 0 6px 0;font-size:13px;color:#4b5563;">Type: {{ $event['type'] ?? 'News' }}@if(!empty($event['event_date'])) | Date: {{ \Illuminate\Support\Carbon::parse($event['event_date'])->format('M d, Y') }}@endif</p>
    <p style="margin:0;font-size:14px;line-height:1.6;color:#374151;">{{ $event['description'] ?? '' }}</p>
</div>
@endforeach
<p style="margin:20px 0 0 0;font-size:15px;line-height:1.6;">Regards,<br><strong>LiVCCI Secretariat</strong></p>
<p style="margin:16px 0 0 0;font-size:12px;line-height:1.6;color:#6b7280;">Livingstone Chamber of Commerce, [Your Address], Livingstone, Zambia.</p>
<p style="margin:8px 0 0 0;font-size:12px;line-height:1.6;color:#6b7280;">You are receiving this because you registered for the LiVCCI Member Portal. To manage notifications, login to your dashboard.</p>
</td></tr>
</table>
</td></tr>
</table>
</body>
</html>
