Function Authenticate(){
$email = read-host -Prompt "Please enter the email for the determined account." # We start by making an email variable, and requesting the email for the user that wants to log in.
$Passwd = read-host -Prompt "Please enter the password for the determined account." -AsSecureString # The next step is requesting the password from the user, and storing it as an encrypted securestring. 

# We then immediately fuck the previously established concept of an securestring with these next two lines of wizardry. I will attempt to describe their use as well as I can. For more info see: https://www.morgantechspace.com/2014/12/Powershell-Convert-SecureString-to-PlainText.html
$PwdPointer = [Runtime.InteropServices.Marshal]::SecureStringToBSTR($Passwd) # The fucking of securestrings starts by making a pointer, called PwdPointer. This pointer (an unmanaged binary string) is set as equal to the contents of the managed securestring Passwd that was created above using the .NET Marshal.SecureStringToBSTR Method. For more info see: https://docs.microsoft.com/en-us/dotnet/api/system.runtime.interopservices.marshal.securestringtobstr?view=netframework-4.8
$Passwd = [Runtime.InteropServices.Marshal]::PtrToStringAuto($PwdPointer) # Then a managed string is allocated and the characters in the pointer are copied to the managed string, which is passed back to the Passwd variable. This is done with the .NET Marshal.PrtToStringAuto Method. For more info see: https://docs.microsoft.com/en-us/dotnet/api/system.runtime.interopservices.marshal.ptrtostringauto?view=netframework-4.8
# TL;DR: Make a pointer. Use .NET magic to pull the data of the Passwd variable from system memory and give it to the pointer. Take the pointer and set it back to a usable plaintext string of what the user entered in the password field.  

$WebRequest = invoke-webrequest -uri <PleasePutUriHere> -SessionVariable Session #This line initializes the variable WebRequest, and invokes a request to the defined page. We expect it to return a form containing an form ID, an empty username field, and an empty passwd field. We also expect it to return a set of cookies associated with the user session. This session variable is called Session. 

$fID = $WebRequest.Forms.Fields.form_id # We take a look at the result of the webrequest, and we grab the value of form_id and pass it to the variable fID.
$Response = @{"form_id" = $fID;"form_name" = "login";"email_address" = $email;"password" = $Passwd;"login_submit" = "Login"} #This line is the response information we will pass back to the site to authenticate. It is made up of an array with the three previously specified values, and with the name of the form, and  a login action.
$Header = @{Accept = '*/*'} #This field is the Header field, which allows us to accept any and all content types

$WebRequest = invoke-webrequest -uri  -WebSession $Session -Method POST -Body $Response -Headers $Header #This line sends the authentication data to the page and allows us to log in. 
}
