if [ $# -eq 0 ]
then
	echo "Usage: newweb <name>" >&2 && exit 1
fi

function newHTML()
{
cat << eof
<!DOCTYPE html>
<html lang="en">
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<link rel="stylesheet" href="styles.css">
	<title>Hatsune Miku is cute</title>
</head>
<body>
	<h1>Hatsune Miku is cute</h1>
	<!-- Your HTML content goes here -->

	<script src="script.js"></script>
</body>
</html>
eof
}

for name in "$@"
do
	mkdir "$name" && (
		cd "$name";
		touch styles.css;
		newHTML > index.html
	)
done
