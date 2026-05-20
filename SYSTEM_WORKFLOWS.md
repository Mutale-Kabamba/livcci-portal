# LivCCI Portal - Visual Workflows & Interface Guide

## Table of Contents
1. [User Journey Maps](#user-journey-maps)
2. [Admin Workflows](#admin-workflows)
3. [System Data Flow](#system-data-flow)
4. [Interface Overview](#interface-overview)

---

## User Journey Maps

### Journey 1: New Business Owner Joining

```
START: Business Owner

│
├─→ Visits Website (/)
│   ├─→ Browses About page
│   ├─→ Reads Membership benefits
│   └─→ Sees "Join the Chamber" button
│
├─→ Clicks "Apply for Membership"
│   └─→ Redirected to /register
│
├─→ Creates Account
│   ├─→ Email
│   ├─→ Password
│   └─→ Verifies email
│
├─→ Logs In
│   └─→ Redirected to /dashboard
│
├─→ Starts Business Profile (/directory/join)
│   ├─→ Company Name: "Zesco Tours"
│   ├─→ Sector: "Tourism"
│   ├─→ Description: "Adventure tours in the falls"
│   ├─→ Contact info, website, social media
│   └─→ Uploads logo/image
│
├─→ Submits Application
│   └─→ Status: PENDING ⏳
│
├─→ Receives Email
│   └─→ "Your application is under review"
│
├─→ Waits for Approval
│   └─→ Checks dashboard daily
│
├─→ Admin Approves (Next Day)
│   └─→ Status Changes: APPROVED ✅
│
├─→ Receives Approval Email
│   ├─→ "You're approved!"
│   ├─→ "Your business now appears in directory"
│   └─→ "You can now view available invoices"
│
├─→ Business Now in Public Directory
│   └─→ Visible at /directory
│   └─→ Other people can see and contact them
│
└─→ END: Active Member
```

### Journey 2: Paying Membership Fees

```
START: Approved Member

│
├─→ Admin Creates Invoice
│   ├─→ Amount: $500 (annual fee)
│   ├─→ Due Date: 30 days
│   └─→ Invoice ID: INV-0001
│
├─→ System Sends Email with Invoice
│   └─→ Attached: Invoice PDF
│
├─→ Member Receives Email
│   ├─→ Views attached invoice
│   └─→ Has 30 days to pay
│
├─→ Member Makes Payment
│   ├─→ Pays via bank transfer
│   ├─→ OR pays via cash
│   └─→ Gets transaction reference
│
├─→ Member Notifies Admin
│   ├─→ Sends proof of payment
│   └─→ OR uploads receipt in dashboard
│
├─→ Admin Records Payment
│   ├─→ Goes to /admin/members/{profile}
│   ├─→ Clicks "Record Payment"
│   ├─→ Enters: Amount, Date, Method, Reference
│   └─→ Clicks "Submit"
│
├─→ System Automatically:
│   ├─→ Marks Invoice as "PAID" ✓
│   ├─→ Updates Membership Expiry: +1 Year
│   ├─→ Status remains: "APPROVED"
│   ├─→ Generates Receipt PDF
│   └─→ Sends receipt email
│
├─→ Member Receives Receipt Email
│   ├─→ Confirms payment received
│   ├─→ Shows payment date & amount
│   ├─→ Shows new expiry date
│   └─→ Attached: Receipt PDF
│
├─→ Member Dashboard Updates
│   ├─→ Outstanding Dues: $0
│   ├─→ Status: Active (Green ✓)
│   ├─→ Expiry Date: Next Year
│   └─→ Can download receipt in history
│
└─→ END: Membership Active & Current
```

### Journey 3: Directory Listing Process

```
START: Viewing the Directory

│
├─→ Public Visitor goes to /directory
│   └─→ NO login required
│
├─→ Sees List of All Approved Businesses
│   ├─→ Company Name
│   ├─→ Sector Category
│   ├─→ Business Description
│   ├─→ Contact Information (Phone, Email)
│   └─→ Logo/Image
│
├─→ Can Filter by Sector
│   ├─→ Tourism
│   ├─→ Hospitality
│   ├─→ Agriculture
│   ├─→ Retail
│   └─→ etc.
│
├─→ Can Search by Name
│   ├─→ Type business name
│   └─→ Instant results
│
├─→ Clicks on Business Card
│   └─→ Goes to /directory/{business-slug}
│
├─→ Views Detailed Business Page
│   ├─→ Full company description
│   ├─→ All contact methods
│   ├─→ Website link
│   ├─→ Social media links
│   ├─→ Company logo
│   └─→ Business location map (if available)
│
├─→ Can Contact Business
│   ├─→ Click phone: Opens dialer
│   ├─→ Click email: Opens email
│   └─→ Click website: Opens link
│
├─→ Can Share Business
│   ├─→ Share on social media
│   ├─→ Send to friend via email
│   └─→ Get business link
│
└─→ END: Connected with Business
```

---

## Admin Workflows

### Admin Workflow 1: Approving New Members

```
┌─────────────────────────────────────────────────────┐
│           ADMIN: Member Approval Workflow            │
└─────────────────────────────────────────────────────┘

Start: Admin logs in to /admin

├─→ Dashboard shows:
│   └─→ "3 new applications pending review"
│
├─→ Goes to Member Management
│   └─→ Filter: Status = "PENDING"
│
├─→ Sees List of Pending Businesses
│   ├─→ Company Name
│   ├─→ Owner Name
│   ├─→ Sector
│   ├─→ Application Date
│   └─→ "Review" button
│
├─→ Clicks "Review" on "Zesco Tours"
│
├─→ Views Application Details
│   ├─→ Company description
│   ├─→ Contact information
│   ├─→ Website/Social media
│   ├─→ Owner details
│   ├─→ Logo image
│   └─→ Checks data accuracy
│
├─→ Decision Time:
│   │
│   ├─→ IF Legitimate Business:
│   │   ├─→ Clicks "APPROVE"
│   │   └─→ Status changes to: APPROVED ✓
│   │
│   └─→ IF Suspicious/Invalid:
│       ├─→ Clicks "REJECT"
│       └─→ Status remains: INACTIVE ✗
│
├─→ System Automatically Sends Email
│   ├─→ If Approved: "Welcome! Your business is approved!"
│   ├─→ If Rejected: "Thank you for applying. Unfortunately..."
│   └─→ Shows next steps
│
├─→ Dashboard Updates
│   └─→ "2 applications pending" (one processed)
│
└─→ End: Member status updated
```

### Admin Workflow 2: Recording Payments

```
┌─────────────────────────────────────────────────────┐
│         ADMIN: Payment Recording Workflow            │
└─────────────────────────────────────────────────────┘

Start: Payment received from member

├─→ Admin goes to /admin/members/{profile}
│   └─→ Example: /admin/members/zesco-tours
│
├─→ Sees Member Details
│   ├─→ Status: APPROVED ✓
│   ├─→ Outstanding Dues: $500
│   ├─→ Membership Expiry: [date]
│   └─→ Payment History: [list]
│
├─→ Clicks "Record Payment"
│   └─→ Payment form opens
│
├─→ Fills Payment Details
│   ├─→ Amount: $500
│   ├─→ Date: 2026-05-20
│   ├─→ Method:
│   │   ├─→ Cash
│   │   ├─→ Bank Transfer
│   │   ├─→ Check
│   │   └─→ Online
│   ├─→ Reference: "TXN-123456"
│   └─→ (Optional) Notes: "Received via direct deposit"
│
├─→ Clicks "Submit"
│   └─→ Form validates
│
├─→ System Processes Payment
│   ├─→ Creates Payment Record
│   ├─→ Finds Invoice (INV-0001)
│   ├─→ Updates Invoice Status: PAID ✓
│   ├─→ Calculates New Expiry: +1 Year
│   ├─→ Updates Member Record
│   ├─→ Generates Receipt PDF
│   ├─→ Prepares Confirmation Email
│   └─→ Saves everything
│
├─→ Confirmation Message
│   ├─→ "Payment recorded successfully"
│   ├─→ Updated Member Info shown
│   │   ├─→ Outstanding Dues: $0
│   │   ├─→ Status: Active
│   │   └─→ Expiry: [new date]
│   └─→ Receipt generated
│
├─→ Automated Email Sent
│   ├─→ To: member@company.com
│   ├─→ Subject: "Payment Receipt - LivCCI"
│   ├─→ Body: Thanks for payment
│   ├─→ Attached: Receipt PDF
│   └─→ Shows new expiry date
│
└─→ End: Payment complete, member notified
```

### Admin Workflow 3: Generating Reports

```
┌─────────────────────────────────────────────────────┐
│      ADMIN: Report Generation Workflow              │
└─────────────────────────────────────────────────────┘

Start: Admin needs insights

├─→ Admin goes to /admin/reports
│   └─→ "Reports Center"
│
├─→ Sees Report Options
│   ├─→ Membership Report
│   ├─→ Revenue Report
│   └─→ Sector Analysis Report
│
├─→ Selects "Membership Report"
│   └─→ Report customization form opens
│
├─→ Chooses Parameters
│   ├─→ Date Range:
│   │   ├─→ From: January 1, 2026
│   │   └─→ To: May 20, 2026
│   ├─→ Filter by Status:
│   │   ├─→ Approved ✓
│   │   ├─→ Pending ✓
│   │   └─→ Inactive ✓
│   └─→ Includes Sector Breakdown: YES
│
├─→ Clicks "Generate Report"
│   └─→ System processes...
│
├─→ Report Generated with:
│   ├─→ Total Members: 47
│   ├─→ Approved: 45
│   ├─→ Pending: 2
│   ├─→ Inactive: 0
│   ├─→ Members by Sector:
│   │   ├─→ Tourism: 15 (32%)
│   │   ├─→ Hospitality: 12 (25%)
│   │   ├─→ Retail: 10 (21%)
│   │   ├─→ Agriculture: 8 (17%)
│   │   └─→ Other: 2 (5%)
│   ├─→ New Members This Period: 8
│   └─→ Growth Rate: +20%
│
├─→ Report Display Options
│   ├─→ View on Screen
│   ├─→ Download as PDF
│   ├─→ Download as Excel
│   ├─→ Print
│   └─→ Email to Staff
│
├─→ Admin Downloads PDF
│   └─→ Saves to computer
│
└─→ End: Report ready for stakeholders
```

---

## System Data Flow

### When Someone Joins

```
┌──────────────────────────────────────────────────────────┐
│          DATA FLOW: New Member Registration              │
└──────────────────────────────────────────────────────────┘

New Business Owner
        │
        ↓
Fills Registration Form
  ├─ Name, Email, Password
  ├─ Company Name
  ├─ Sector
  ├─ Description
  └─ Contact Info
        │
        ↓
Data Validated
  ├─ Email format correct?
  ├─ Password strong enough?
  ├─ All required fields filled?
  └─ Company name unique?
        │
        ↓
Saved to Database
  ├─ users table (email, password)
  ├─ business_profiles table (company info)
  └─ Assigned status: PENDING
        │
        ↓
Email Verification Sent
  ├─ Verification link in email
  ├─ Owner clicks link
  └─ Email confirmed
        │
        ↓
Account Active
  └─ Owner can log in
        │
        ↓
Notification to Admin
  └─ Admin sees pending application
        │
        ↓
Admin Reviews & Approves
  └─ Status: PENDING → APPROVED
        │
        ↓
Confirmation Email to Owner
  └─ "You're approved! Join the directory"
        │
        ↓
Business Appears in Directory
  └─ Public can see at /directory
```

### When Invoice is Created

```
┌──────────────────────────────────────────────────────────┐
│        DATA FLOW: Invoice Creation to Payment            │
└──────────────────────────────────────────────────────────┘

Admin Creates Invoice
  ├─ Amount: $500
  ├─ Description: "Annual Membership"
  └─ Due Date: 30 days
        │
        ↓
Invoice Record Created
  ├─ Database: invoices table
  ├─ Status: UNPAID
  ├─ Invoice Number: Auto-generated (INV-0001)
  └─ PDF Generated
        │
        ↓
Email Sent to Member
  ├─ Subject: "Invoice Issued"
  ├─ Body: Invoice details
  ├─ Attachment: Invoice PDF
  └─ Payment Instructions
        │
        ↓
Member Receives Email
  ├─ Reviews invoice
  ├─ Sees amount owed
  └─ Sees due date
        │
        ↓
Member Makes Payment
  └─ Bank transfer / Cash
        │
        ↓
Admin Records Payment
  ├─ Amount
  ├─ Date
  ├─ Method
  └─ Reference
        │
        ↓
Payment Processed
  ├─ Database Updated:
  │  ├─ business_payments table: Record saved
  │  ├─ invoices table: Status → PAID
  │  └─ business_profiles table: Expiry → +1 Year
  ├─ Receipt Generated
  └─ Email Queued
        │
        ↓
Confirmation Email Sent
  ├─ Subject: "Payment Received"
  ├─ Body: Thank you message
  ├─ Attachment: Receipt PDF
  ├─ New expiry date
  └─ Next renewal date
        │
        ↓
Member Dashboard Updated
  ├─ Outstanding Dues: $0
  ├─ Status: Active (Green ✓)
  └─ Expiry Date: Updated
        │
        ↓
Member Receives Email
  └─ Reviews receipt
```

---

## Interface Overview

### Public Website Pages

#### 1. Homepage (/)
```
┌────────────────────────────────────────────┐
│            HEADER / NAVIGATION              │
│  Logo  |  Home  About  Sectors  News        │
│        |  Directory  Membership  Leadership  │
│        └─ Login | Join Chamber             │
├────────────────────────────────────────────┤
│                                            │
│         [HERO IMAGE - BANNER]              │
│    "Driving Economic Growth in Zambia"     │
│    [Join Chamber] [Explore Directory]      │
│                                            │
├────────────────────────────────────────────┤
│  QUICK STATS:                              │
│  ✓ 45 Approved Members  ✓ 8 Events         │
│  ✓ 4 Core Sectors                          │
├────────────────────────────────────────────┤
│  QUICK CARDS:                              │
│  [New Member]  [Find Partners] [News]      │
├────────────────────────────────────────────┤
│  CHAIRPERSON MESSAGE:                      │
│  "Dear Members and Partners..."            │
├────────────────────────────────────────────┤
│  LATEST NEWS:                              │
│  • Event 1 - May 25                        │
│  • Event 2 - June 1                        │
│  • News Update 1                           │
├────────────────────────────────────────────┤
│  CORE VALUES:                              │
│  [Value 1] [Value 2] [Value 3]             │
├────────────────────────────────────────────┤
│            FOOTER                          │
│  Contact | Email | Social Media            │
└────────────────────────────────────────────┘
```

#### 2. Member Directory (/directory)
```
┌────────────────────────────────────────────┐
│             MEMBER DIRECTORY               │
├────────────────────────────────────────────┤
│  Search [__________] Filter by Sector [__] │
│  [Tourism] [Hospitality] [Retail] [Agri]   │
├────────────────────────────────────────────┤
│  RESULTS: 45 members found                 │
├────────────────────────────────────────────┤
│                                            │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐ │
│  │ Safari   │  │ Hotel X  │  │ Market   │ │
│  │ Tours    │  │          │  │ Place    │ │
│  │Tourism   │  │Hospitality│ │  Retail  │ │
│  │📞 📧 🌐  │  │📞 📧 🌐  │  │📞 📧 🌐 │ │
│  └──────────┘  └──────────┘  └──────────┘ │
│                                            │
│  ┌──────────┐  ┌──────────┐               │
│  │ Farm X   │  │ Shop Y   │               │
│  │          │  │          │               │
│  │Agriculture│ │  Retail  │               │
│  │📞 📧 🌐  │  │📞 📧 🌐  │               │
│  └──────────┘  └──────────┘               │
│                                            │
│  [LOAD MORE] or [View Next 5]              │
└────────────────────────────────────────────┘
```

#### 3. Member Dashboard (/dashboard)
```
┌────────────────────────────────────────────┐
│  Welcome, John Smith                       │
├────────────────────────────────────────────┤
│  OUTSTANDING DUES                          │
│  ┌──────────────────────────────────────┐  │
│  │ Amount Owed: $0                      │  │
│  │ All invoices paid ✓                  │  │
│  └──────────────────────────────────────┘  │
├────────────────────────────────────────────┤
│  MY BUSINESSES                             │
│  ┌──────────────────────────────────────┐  │
│  │ Zesco Tours                          │  │
│  │ Status: APPROVED ✓ (Green)           │  │
│  │ Sector: Tourism                      │  │
│  │ Expiry: 2027-05-20                   │  │
│  │ Outstanding: $0                      │  │
│  │ [View] [Edit] [Invoice History]      │  │
│  └──────────────────────────────────────┘  │
│                                            │
│  ┌──────────────────────────────────────┐  │
│  │ Travel Agency                        │  │
│  │ Status: PENDING ⏳ (Yellow)          │  │
│  │ Sector: Tourism                      │  │
│  │ Applied: 2026-05-10                  │  │
│  │ [View] [Edit] [Cancel]               │  │
│  └──────────────────────────────────────┘  │
├────────────────────────────────────────────┤
│  QUICK ACTIONS                             │
│  [Join Directory] [Pay Dues] [Update       │
│   Profile] [Download Certificate]          │
├────────────────────────────────────────────┤
│  RECENT INVOICES                           │
│  • INV-0001: $500 - PAID ✓ - May 20       │
│  • INV-0002: $500 - UNPAID - May 22       │
│    [View PDF] [Download Receipt]           │
└────────────────────────────────────────────┘
```

### Admin Dashboard (/admin)

```
┌────────────────────────────────────────────┐
│  ADMIN DASHBOARD                           │
│  Welcome, Admin User                       │
├────────────────────────────────────────────┤
│  QUICK STATS                               │
│  ┌─────────┬─────────┬─────────┬────────┐  │
│  │ Members │ Revenue │ Pending │ Events │  │
│  │   45    │ $22,500 │   2     │   8    │  │
│  └─────────┴─────────┴─────────┴────────┘  │
├────────────────────────────────────────────┤
│  RECENT ACTIVITIES                         │
│  • Zesco Tours - APPROVED (Today)          │
│  • Payment $500 recorded - Safari Ltd      │
│  • New Event created - June 5 Workshop     │
│  • Invoice INV-0002 sent to Travel Co.     │
├────────────────────────────────────────────┤
│  TASKS                                     │
│  ⚠️  2 Pending Approvals                   │
│  ⚠️  3 Overdue Payments                    │
│  ⚠️  5 Expiring Soon (< 30 days)           │
├────────────────────────────────────────────┤
│  MAIN MENU                                 │
│  ┌────────────────────────────────────┐   │
│  │ 👥 Accounts Management             │   │
│  │ 📋 Member Management               │   │
│  │ 💰 Financial Management            │   │
│  │ 📢 Content & Events                │   │
│  │ 📈 Reports                         │   │
│  │ 🎯 Strategic Goals                 │   │
│  └────────────────────────────────────┘   │
└────────────────────────────────────────────┘
```

---

## Summary

The LivCCI Portal system is built as:
1. **Three separate but connected systems** (Public, Member, Admin)
2. **Database-driven** (stores all business logic)
3. **Automated workflows** (emails, status updates)
4. **Role-based access** (different people see different things)
5. **Data flowing** between components seamlessly

Each part works together to create a complete membership management platform!

