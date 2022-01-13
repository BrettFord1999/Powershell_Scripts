PowerShell.exe -windowstyle hidden {
Function Generate-Form {

    Add-Type -AssemblyName System.Windows.Forms    
    Add-Type -AssemblyName System.Drawing

        # Build Form
    $Form = New-Object System.Windows.Forms.Form
    $Form.Text = "You have a big decision to make"
    $Form.Size = New-Object System.Drawing.Size(500,250)
    $Form.StartPosition = "CenterScreen"
    $Form.Topmost = $True
    $Form.AutoSize = $True

    # Add Button
    $Button = New-Object System.Windows.Forms.Button
    $Button.Location = New-Object System.Drawing.Size(185,85)
    $Button.Size = New-Object System.Drawing.Size(120,23)
    $Button.Text = "Crash Your computer"
    $Button.AutoSize = $True
   


    $Form.Controls.Add($Button)

    #Add Button event 
    $Button.Add_Click(
        {    
		get-service | stop-service
        }
    )
     
    #Show the Form 
    $form.ShowDialog()| Out-Null 
 
} #End Function 

 #Call the Function 
Generate-Form






}
