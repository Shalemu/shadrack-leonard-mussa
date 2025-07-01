<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Children Report</title>
    <style>
        body {
            font-family: DejaVu Sans, sans-serif;
            font-size: 12px;
        }
        h2 {
            text-align: center;
            margin-bottom: 20px;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 5px;
        }
        th, td {
            border: 1px solid #000;
            padding: 6px;
            text-align: left;
        }
        th {
            background-color: #eeeeee;
        }
    </style>
</head>
<body>
    <h2>Children Report</h2>

    <table>
        <thead>
            <tr>
                <th>#</th>
                <th>Name</th>
                <th>DOB</th>
                <th>Gender</th>
                <th>Class Level</th>
                <th>Street</th>
                <th>Phone</th>
                <th>Parent name</th>
                <th>School</th>
                <th>Baptized</th>
            </tr>
        </thead>
        <tbody>
            @foreach ($records as $index => $child)
                <tr>
                    <td>{{ $index + 1 }}</td>
                    <td>{{ $child->name }}</td>
                    <td>{{ $child->dob }}</td>
                    <td>{{ $child->gender }}</td>
                    <td>{{ $child->class_level }}</td>
                    <td>{{ $child->street }}</td>
                    <td>{{ $child->phone }}</td>
                    <td>{{ $child->guardian_name }}</td>
                    <td>{{ $child->school }}</td>
                    <td>{{ $child->baptized }}</td>
                </tr>
            @endforeach
        </tbody>
    </table>
</body>
</html>
