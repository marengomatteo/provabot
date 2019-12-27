<?php
$content = file_get_contents("php://input");
$update = json_decode($content, true);

if(!$update)
{
  exit;
}

$message = isset($update['message']) ? $update['message'] : "";
$messageId = isset($message['message_id']) ? $message['message_id'] : "";
$chatId = isset($message['chat']['id']) ? $message['chat']['id'] : "";
$firstname = isset($message['chat']['first_name']) ? $message['chat']['first_name'] : "";
$lastname = isset($message['chat']['last_name']) ? $message['chat']['last_name'] : "";
$username = isset($message['chat']['username']) ? $message['chat']['username'] : "";
$date = isset($message['date']) ? $message['date'] : "";
$text = isset($message['text']) ? $message['text'] : "";

$text = trim($text);
$text = strtolower($text);
header("Content-Type: application/json");
$response = '';

if(strpos($text, "/start") === 0 || $text == 'ciao')
{
	$response = "Ciao $firstname, sono il bot di tiger trading, il mio compito è quello di inviare segnali di trading.
	Per problemi contattate @mareefx.";
}
elseif(strpos($text, "/help") === 0)
{
	$response = "Ciao hai bisogno di aiuto?";
}
elseif($message == 'si')
{
	$response = 'Per problemi puoi contattare @mareefx.';
}
	
$parameters = array('chat_id' => $chatId, "text" => $response);
$parameters["method"] = "sendMessage";
echo json_encode($parameters);
