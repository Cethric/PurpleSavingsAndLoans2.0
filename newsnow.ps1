function newSNOWChange {
    param(
        [string][Parameter(Mandatory = $true)]$SNOWuser,
        [string][Parameter(Mandatory = $true)]$SNOWpass,
        [string][Parameter(Mandatory = $true)]$instanceName,
        [string][Parameter(Mandatory = $true)]$CRShortDesc,
        [string][Parameter(Mandatory = $true)]$CRFullDesc,
        [string][Parameter(Mandatory = $true)]$CRJustificiation,
        [string][Parameter(Mandatory = $true)]$CRPlan,
        [string][Parameter(Mandatory = $true)]$CRTestPlan,
        [string][Parameter(Mandatory = $true)]$CRBackoutPlan,
        [string][Parameter(Mandatory = $true)]$CRSummaryNotes
    )

    $base64AuthInfo = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("{0}:{1}" -f $SNOWuser, $SNOWpass)))

    $headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
    $headers.Add('Authorization', ('Basic {0}' -f $base64AuthInfo))
    $headers.Add('Accept', 'application/json')
    $headers.Add('Content-Type', 'application/json')

    $CRuri = "https://$instanceName.service-now.com/api/now/table/change_request"

    $Postmethod = "post"

    $CRbody = @{ 
        requested_by      = "Geordie Guy"
        category          = "Other"
        service_offering  = "Other"
        reason            = "starship upgrade"
        u_client_impact   = "No"
        start_date        = "2020-11-1 01:00:00"
        end_date          = "2020-11-30 23:00:00"
        watch_list        = "Watch List Sys_ID"
        Parent            = "Parent Incident or Change Request"
        urgency           = "2"
        risk              = "4"
        type              = "Standard"
        state             = "1"
        assignment_group  = "Assigned To's Group Sys_ID"
        assigned_to       = "Assigned To Sys_ID"
        short_description = $CRShortDesc
        description       = $CRFullDesc
        justification     = $CRJustificiation
        change_plan       = $CRPlan
        test_plan         = $CRTestPlan
        backout_plan      = $CRBackoutPlan
        u_change_summary  = $CRSummaryNotes
    }
    $CRbodyjson = $CRbody | ConvertTo-Json

    try {
        $ChangePOSTResponse = Invoke-RestMethod -Method $Postmethod -Uri $CRuri -Body $CRbodyjson -TimeoutSec 100 -Headers $headers -ContentType "application/json"
    }
    catch {
        Write-Host $_.Exception.ToString()
        $error[0] | Format-List -Force
    }

    $ChangeID = $ChangePOSTResponse.result.number
    $ChangeSysID = $ChangePOSTResponse.result.sys_id

    if ($ChangeID -ne $null) {
        "Created Change With ID:$ChangeID"
        "Change created With Sys_ID:$ChangeSysID"
    }
    else {
        "Change Not Created"
    }
}