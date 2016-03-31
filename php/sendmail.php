<?php
/**
 * VERSION: 1.0
 * DATE: 10/09/2010
 * PHP
 * AUTHOR: J. De Smedt
 **/
$contact_name = $_POST['name'];
$contact_mail = $_POST['mail'];
$contact_subject = $_POST['subject'];
$contact_message = $_POST['message'];

if( $contact_name != "" )
{
	$receiver = "contact@daelysid.net";
	$client_ip = $_SERVER['REMOTE_ADDR'];
	$email_body = "Name: ".$contact_name."\nEmail: <".$contact_mail.">\n\nSubject: ".$contact_subject."\n\nMessage: \n\n".$contact_message." \n\nIP: ".$client_ip."\n\n";
	$extra = "From: $sender\r\n" . "Reply-To: $sender \r\n" . "X-Mailer: PHP/" . phpversion();

	if( mail( $receiver, "Contact Form - $contact_subject", $email_body, $extra ) )
	{
		echo "success=yes";
	}
	else
	{
		echo "success=no";
	}
}

?>
