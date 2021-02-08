param([string] $EventName, [string]$Type, [string]$Created, [bool]$Debug = $false)

if (!$EventName) {
    throw "Must provide EventName parameter"
}
if (!$Type) {
    throw "Must provide Type parameter"
}
if (!$Created) {
    throw "Must provide Created parameter"
}
if (![datetime]::TryParseExact($Created, 'yyyy-MM-ddTHH:mm:ssZ', $null)) {
    throw "Invalid Created date format"
}
$GithubRef = $Env:GITHUB_REF
$GithubRepository = $Env:GITHUB_REPOSITORY
if (!$GithubRef) {
    throw "Must provide GITHUB_REF environment variable"
}
if (!$GithubRepository) {
    throw "Must provide GITHUB_REPOSITORY environment variable"    
}

if ($Debug) {
    Write-Host EventName=$EventName
    Write-Host Type=$Type
    Write-Host Created=$Created
    Write-Host GithubRef=$GithubRef
    Write-Host GithubRepository=$GithubRepository
}

if ($GithubRef.StartsWith("refs/tags/$Type/v")) {
    $Version = $GithubRef.Substring("refs/tags/$Type/v".Length)
}
else {
    throw "Failed to extract version"
}

if ($Version -notmatch '^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}(\.[0-9]{1,3})$') {
    throw "Version must have format #.#.#.#"
}

TAGS="ghcr.io/${GithubRepository}:${VERSION}"

Write-Host ::set-output name=version::$Version
Write-Host ::set-output name=type::$Type
Write-Host ::set-output name=tags::$Tags
Write-Host ::set-output name=created::$Created
