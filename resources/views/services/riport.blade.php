<style>
.th{
        background-color: #f5f5a5;
        color: #000;
    }

    /* .report-table td:first-child {
    background-color: #f5f5a5;
    font-weight: 600;
} */

    .report-title {
        font-size: 24px;
        font-weight: bold;
        margin-top: 20px;
    }

    .section-title {
        font-size: 18px;
        font-weight: 600;
        margin-top: 25px;
        background: #f5f5a5;
        padding: 5px 10px;
    }

    .table td, .table th {
        vertical-align: middle;
    }

    .summary-box {
        border: 1px solid #ccc;
        padding: 15px;
        border-radius: 8px;
        margin-top: 10px;
        background-color: #fcfcfc;
    }
</style>

<div class="container">
   

    <div class="row">
        <div class="col-md-4 summary-box">
            <h5 class="section-title">Today - {{ date('Y-m-d') }}</h5>
            <table class="table table-bordered report-table">
                <tr>
                    <td>Offering (TZS)</td>
                    <td>85,000</td>
                </tr>
                <tr>
                    <td>Men</td>
                    <td>35</td>
                </tr>
                <tr>
                    <td>Women</td>
                    <td>50</td>
                </tr>
                <tr>
                    <td>Children</td>
                    <td>20</td>
                </tr>
                <tr>
                    <td>Visitors</td>
                    <td>5</td>
                </tr>
                <tr>
                    <td>Total Attendance</td>
                    <td>110</td>
                </tr>
                <tr>
                    <td>Preacher</td>
                    <td>Pastor John</td>
                </tr>
                <tr>
                    <td>Service Leader</td>
                    <td>Sister Mary</td>
                </tr>
            </table>
        </div>

        <div class="col-md-4 summary-box">
            <h5 class="section-title">This Month - June 2025</h5>
            <table class="table table-bordered report-table">
                <tr>
                    <td>Total Offering</td>
                    <td>455,000</td>
                </tr>
                <tr>
                    <td>Total Visitors</td>
                    <td>18</td>
                </tr>
                <tr>
                    <td>Average Attendance</td>
                    <td>95</td>
                </tr>
                <tr>
                    <td>Top Preacher</td>
                    <td>Pastor Grace</td>
                </tr>
            </table>
        </div>

        <div class="col-md-4 summary-box">
            <h5 class="section-title">Last Sunday - {{ date('Y-m-d', strtotime('last sunday')) }}</h5>
            <table class="table table-bordered report-table">
                <tr>
                    <td>Offering</td>
                    <td>90,000</td>
                </tr>
                <tr>
                        <td class="th">Total Attendance</td>
                    <td>100</td>
                </tr>
                <tr>
                    <td>Preacher</td>
                    <td>Evangelist Peter</td>
                </tr>
                <tr>
                    <td>Leader</td>
                    <td>Brother James</td>
                </tr>
            </table>
        </div>
    </div>
    
</div>
