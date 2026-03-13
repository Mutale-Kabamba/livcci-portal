<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>LiVCCI Membership Certificate</title>
    <style>
        body {
            margin: 0;
            padding: 30px;
            font-family: DejaVu Sans, Arial, sans-serif;
            color: #1f2937;
            background: #f8fafc;
        }

        .certificate {
            border: 8px solid #1D2A68;
            padding: 36px;
            background: #ffffff;
            position: relative;
        }

        .inner-border {
            border: 2px solid #1876C3;
            padding: 28px;
        }

        .top-row {
            display: table;
            width: 100%;
            margin-bottom: 24px;
        }

        .logo-box,
        .title-box {
            display: table-cell;
            vertical-align: middle;
        }

        .logo-box {
            width: 180px;
        }

        .logo-placeholder {
            border: 2px dashed #1876C3;
            color: #1876C3;
            font-size: 12px;
            text-align: center;
            padding: 20px 12px;
            font-weight: 700;
        }

        .title-box {
            text-align: right;
        }

        .title {
            font-size: 30px;
            font-weight: 800;
            color: #1D2A68;
            margin: 0;
        }

        .subtitle {
            font-size: 14px;
            color: #4b5563;
            margin-top: 8px;
        }

        .main-text {
            text-align: center;
            margin: 34px 0;
        }

        .company-name {
            font-size: 34px;
            line-height: 1.2;
            color: #1D2A68;
            font-weight: 800;
            margin: 16px 0;
        }

        .meta {
            margin-top: 40px;
            display: table;
            width: 100%;
        }

        .meta-cell {
            display: table-cell;
            width: 50%;
            vertical-align: top;
            font-size: 13px;
            color: #374151;
        }

        .label {
            display: block;
            color: #6b7280;
            font-size: 11px;
            text-transform: uppercase;
            letter-spacing: 0.08em;
            margin-bottom: 6px;
        }

        .value {
            font-size: 16px;
            color: #111827;
            font-weight: 700;
        }
    </style>
</head>
<body>
    <div class="certificate">
        <div class="inner-border">
            <div class="top-row">
                <div class="logo-box">
                    <div class="logo-placeholder">LiVCCI Logo Placeholder</div>
                </div>
                <div class="title-box">
                    <h1 class="title">Membership Certificate</h1>
                    <p class="subtitle">Livingstone Chamber of Commerce and Industry</p>
                </div>
            </div>

            <div class="main-text">
                <p>This is to certify that</p>
                <div class="company-name">{{ $profile->company_name }}</div>
                <p>is a recognized member in good standing with LiVCCI.</p>
            </div>

            <div class="meta">
                <div class="meta-cell">
                    <span class="label">Issue Date</span>
                    <span class="value">{{ \Illuminate\Support\Carbon::parse($issueDate)->format('F d, Y') }}</span>
                </div>
                <div class="meta-cell" style="text-align: right;">
                    <span class="label">Valid Until</span>
                    <span class="value">{{ \Illuminate\Support\Carbon::parse($validUntil)->format('F d, Y') }}</span>
                </div>
            </div>
        </div>
    </div>
</body>
</html>
