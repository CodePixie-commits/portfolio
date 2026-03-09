$html = Get-Content -Path 'c:\Portfolio\index.html' -Raw

# Extract all individual project cards (brutalist-card inner structures)
$cardRegex = '(?s)<div class="col-md-4 col-sm-6">\s*(<div class="brutalist-card p-5 h-100 d-flex flex-column">.*?</div>)\s*</div>'
$cards = [regex]::Matches($html, $cardRegex) | ForEach-Object { $_.Groups[1].Value }

if ($cards.Count -eq 0) {
    Write-Host "No cards found!"
    exit
}

# 1. Generate Desktop Carousel (3 cards per slide)
$desktopCarousel = '<div id="desktopCarousel" class="carousel slide d-none d-lg-block" data-bs-ride="carousel">' + "`r`n"
$desktopCarousel += '<div class="carousel-inner px-md-5">' + "`r`n"

for ($i = 0; $i -lt $cards.Count; $i += 3) {
    $activeClass = if ($i -eq 0) { " active" } else { "" }
    $desktopCarousel += "  <div class=`"carousel-item$activeClass`">`r`n    <div class=`"row g-4`">`r`n"
    
    for ($j = 0; $j -lt 3; $j++) {
        if (($i + $j) -lt $cards.Count) {
            $desktopCarousel += "      <div class=`"col-4`">`r`n        " + $cards[$i+$j] + "`r`n      </div>`r`n"
        }
    }
    
    $desktopCarousel += "    </div>`r`n  </div>`r`n"
}
$desktopCarousel += '</div>' + "`r`n"
$desktopCarousel += '<button class="carousel-control-prev" type="button" data-bs-target="#desktopCarousel" data-bs-slide="prev"><span class="carousel-control-prev-icon" aria-hidden="true"></span><span class="visually-hidden">Previous</span></button>'
$desktopCarousel += '<button class="carousel-control-next" type="button" data-bs-target="#desktopCarousel" data-bs-slide="next"><span class="carousel-control-next-icon" aria-hidden="true"></span><span class="visually-hidden">Next</span></button>'
$desktopCarousel += '</div>' + "`r`n"

# 2. Generate Mobile Carousel (1 card per slide)
$mobileCarousel = '<div id="mobileCarousel" class="carousel slide d-block d-lg-none" data-bs-ride="carousel">' + "`r`n"
$mobileCarousel += '<div class="carousel-inner px-4">' + "`r`n"

for ($i = 0; $i -lt $cards.Count; $i++) {
    $activeClass = if ($i -eq 0) { " active" } else { "" }
    $mobileCarousel += "  <div class=`"carousel-item$activeClass`">`r`n"
    $mobileCarousel += "    " + $cards[$i] + "`r`n"
    $mobileCarousel += "  </div>`r`n"
}

$mobileCarousel += '</div>' + "`r`n"
$mobileCarousel += '<button class="carousel-control-prev" type="button" data-bs-target="#mobileCarousel" data-bs-slide="prev"><span class="carousel-control-prev-icon" aria-hidden="true"></span><span class="visually-hidden">Previous</span></button>'
$mobileCarousel += '<button class="carousel-control-next" type="button" data-bs-target="#mobileCarousel" data-bs-slide="next"><span class="carousel-control-next-icon" aria-hidden="true"></span><span class="visually-hidden">Next</span></button>'
$mobileCarousel += '</div>' + "`r`n"


#Now find the section #work and replace everything from <div id="projectCarousel"... to the end of the section
$sectionStart = '<div id="projectCarousel" class="carousel slide" data-bs-ride="carousel">'
$sectionEnd = '</section>'

$startIndex = $html.IndexOf($sectionStart)
$endIndex = $html.IndexOf($sectionEnd, $startIndex)

if ($startIndex -ne -1 -and $endIndex -ne -1) {
    # Replace the block
    $newHtml = $html.Substring(0, $startIndex) + $desktopCarousel + "`r`n" + $mobileCarousel + "`r`n" + '      <div class="text-center mt-5"><a href="work.html" class="brutalist-button-outline text-decoration-none d-inline-flex align-items-center gap-2">VIEW ALL PROJECTS <i data-lucide="arrow-right"></i></a></div>' + "`r`n    " + $html.Substring($endIndex)
    Set-Content -Path 'c:\Portfolio\index.html' -Value $newHtml
    Write-Host "Successfully generated and injected Two Carousels."
} else {
    Write-Host "Could not find replacement boundaries."
}
