\ProvidesClass{text}
\RequirePackage{xkeyval}
\RequirePackage{xpatch}

\apptocmd{\date}{\def\@dateisdefined{\relax}}{}{}

% Use \iftoggle{isprint}{<If true>}{<If false>} to write code depending on whether this is electronic or print
\newtoggle{isprint} % Default is false

\DeclareOptionX{print}{\toggletrue{isprint}}
\DeclareOptionX*{\PassOptionsToClass{\CurrentOption}{book}}
\ProcessOptionsX*%

\iftoggle{isprint}{%
	\LoadClass[11pt,fleqn]{book}%
}%
{%
	\LoadClass[12pt,fleqn,oneside]{book}%
}%

\RequirePackage{custom}

\iftoggle{isprint}{%
	\usepackage[paperwidth=6in,paperheight=9in,inner=1.125in,outer=0.75in,top=1.0in,bottom=1.0in,headsep=10pt,twoside]{geometry} % Page margins
}
{%
	\usepackage[top=4cm,bottom=4cm,left=4cm,right=4cm,headsep=10pt,a4paper]{geometry} % Page margins
	\AtBeginDocument{%
		\pagenumbering{gobble}% Don't number title page with hyperref.  Otherwise, will complain about duplicate destinations with name page.1
		\begingroup
		\thispagestyle{empty}
		\begin{tikzpicture}[remember picture,overlay]
		\coordinate [below=12cm] (midpoint) at (current page.north);
		\node at (current page.north west)
		{\begin{tikzpicture}[remember picture,overlay]
			\node[anchor=north west,inner sep=0pt] at (0,0) {\includegraphics[width=\paperwidth]{background}}; % Background image
			\draw[anchor=north] (midpoint) node [fill=ocre!30!white,fill opacity=0.6,text opacity=1,inner sep=1cm]{\Huge\centering\bfseries\sffamily\parbox[c][][t]{\paperwidth}{\centering \@title \\[15pt] % Book title
					{\huge \@author}% Author name
					\ifdef{\@dateisdefined}{ \\[12pt]%
					{\Large \@date}}}}{}; % Date
			\end{tikzpicture}};
		\end{tikzpicture}
		\vfill
		\endgroup
	}
	\AfterEndPreamble{\clearpage} % For some reason this throws error if placed in \AtBeginDocument.  (This is executed after the above.)
}

\usepackage{graphicx} % Required for including pictures
\graphicspath{{pictures/}} % Specifies the directory where pictures are stored


%----------------------------------------------------------------------------------------
%	MINI TABLE OF CONTENTS IN PART HEADS
%----------------------------------------------------------------------------------------

% Chapter text styling
\titlecontents{lchapter}[0em] % Indenting
{\addvspace{15pt}\large\sffamily\bfseries} % Spacing and font options for chapters
{\color{ocre}\contentslabel[\Large\thecontentslabel]{1.25cm}\color{ocre}} % Chapter number
{}  
{\color{ocre}\normalsize\sffamily\bfseries\;\titlerule*[.5pc]{.}\;\thecontentspage} % Page number

% Section text styling
\titlecontents{lsection}[0em] % Indenting
{\sffamily\small} % Spacing and font options for sections
{\contentslabel[\thecontentslabel]{1.25cm}} % Section number
{}
{}

% Subsection text styling
\titlecontents{lsubsection}[.5em] % Indentation
{\normalfont\footnotesize\sffamily} % Font settings
{}
{}
{}

%----------------------------------------------------------------------------------------
%	PART HEADINGS
%----------------------------------------------------------------------------------------

% numbered part in the table of contents
\newcommand{\@mypartnumtocformat}[2]{%
	\setlength\fboxsep{0pt}%
	\noindent\colorbox{ocre!20}{\strut\parbox[c][.7cm]{\ecart}{\color{ocre!70}\Large\sffamily\bfseries\centering#1}}\hskip\esp\colorbox{ocre!40}{\strut\parbox[c][.7cm]{\linewidth-\ecart-\esp}{\Large\sffamily\centering#2}}}%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% unnumbered part in the table of contents
\newcommand{\@myparttocformat}[1]{%
	\setlength\fboxsep{0pt}%
	\noindent\colorbox{ocre!40}{\strut\parbox[c][.7cm]{\linewidth}{\Large\sffamily\centering#1}}}%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\newlength\esp
\setlength\esp{4pt}
\newlength\ecart
\setlength\ecart{1.2cm-\esp}
\newcommand{\thepartimage}{}%
\newcommand{\partimage}[1]{\renewcommand{\thepartimage}{#1}}%
\def\@part[#1]#2{%
	\ifnum \c@secnumdepth >-2\relax%
	\refstepcounter{part}%
	\addcontentsline{toc}{part}{\texorpdfstring{\protect\@mypartnumtocformat{\thepart}{#1}}{\partname~\thepart\ ---\ #1}}
	\else%
	\addcontentsline{toc}{part}{\texorpdfstring{\protect\@myparttocformat{#1}}{#1}}%
	\fi%
	\startcontents%
	\markboth{}{}%
	{\thispagestyle{empty}%
		\begin{tikzpicture}[remember picture,overlay]%
		\node at (current page.north west){\begin{tikzpicture}[remember picture,overlay]%	
			\fill[ocre!20](0cm,0cm) rectangle (\paperwidth,-\paperheight);
			\node[anchor=north] at (4cm,-3.25cm){\color{ocre!40}\fontsize{220}{100}\sffamily\bfseries\@Roman\c@part}; 
			\node[anchor=south east] at (\paperwidth-1cm,-\paperheight+1cm){\parbox[t][][t]{8.5cm}{
					\printcontents{l}{0}{\setcounter{tocdepth}{1}}%
			}};
			\node[anchor=north east] at (\paperwidth-1.5cm,-3.25cm){\parbox[t][][t]{15cm}{\strut\raggedleft\color{white}\fontsize{30}{30}\sffamily\bfseries#2}};
			\end{tikzpicture}};
\end{tikzpicture}}%
\@endpart}
\def\@spart#1{%
\startcontents%
\phantomsection
{\thispagestyle{empty}%
	\begin{tikzpicture}[remember picture,overlay]%
	\node at (current page.north west){\begin{tikzpicture}[remember picture,overlay]%	
		\fill[ocre!20](0cm,0cm) rectangle (\paperwidth,-\paperheight);
		\node[anchor=south east] at (\paperwidth-1cm,-\paperheight+1cm){\parbox[t][][t]{8.5cm}{
				\printcontents{l}{0}{\setcounter{tocdepth}{1}}%
		}};
		\node[anchor=north east] at (\paperwidth-1.5cm,-3.25cm){\parbox[t][][t]{15cm}{\strut\raggedleft\color{white}\fontsize{30}{30}\sffamily\bfseries#1}};
		\end{tikzpicture}};
\end{tikzpicture}}
\addcontentsline{toc}{part}{\texorpdfstring{%
	\setlength\fboxsep{0pt}%
	\noindent\protect\colorbox{ocre!40}{\strut\protect\parbox[c][.7cm]{\linewidth}{\Large\sffamily\protect\centering #1\quad\mbox{}}}}{#1}}%
\@endpart}
\def\@endpart{\vfil\newpage
\if@tempswa
\twocolumn
\fi}

%----------------------------------------------------------------------------------------
%	CHAPTER HEADINGS
%----------------------------------------------------------------------------------------
\usepackage{extdash}
\newlength{\chaptermakebox}
\newlength{\chapterheadingposition}
\iftoggle{isprint}{\setlength{\chaptermakebox}{6in}\setlength{\chapterheadingposition}{2.7in}}{\setlength{\chaptermakebox}{22cm}\setlength{\chapterheadingposition}{9cm}}
\newcommand{\thechapterimage}{}%
\newcommand{\chapterimage}[1]{\renewcommand{\thechapterimage}{#1}}%
\def\@makechapterhead#1{%
{\parindent \z@ \raggedright \normalfont
\ifnum \c@secnumdepth >\m@ne
\if@mainmatter
\begin{tikzpicture}[remember picture,overlay]
\node at (current page.north west)
{\begin{tikzpicture}[remember picture,overlay]
	\node[anchor=north west,inner sep=0pt] at (0,0) {\includegraphics[width=\paperwidth]{\thechapterimage}};
	\draw[anchor=west] (\Gm@lmargin,-\chapterheadingposition) node [line width=2pt,rounded corners=15pt,draw=ocre,fill=white,fill opacity=0.5,inner sep=15pt]{\strut\makebox[\chaptermakebox]{}\vphantom{\parbox{\chaptermakebox-8cm}{\huge\sffamily\bfseries\color{black}\thechapter. #1\strut}}};
	\draw[anchor=west] (\Gm@lmargin+.3cm,-\chapterheadingposition) node {\parbox{\chaptermakebox-8cm}{\huge\sffamily\bfseries\color{black}\thechapter. #1\strut}};
	\end{tikzpicture}};
\end{tikzpicture}
\else
\begin{tikzpicture}[remember picture,overlay]
\node at (current page.north west)
{\begin{tikzpicture}[remember picture,overlay]
\node[anchor=north west,inner sep=0pt] at (0,0) {\includegraphics[width=\paperwidth]{\thechapterimage}};
\draw[anchor=west] (\Gm@lmargin,-\chapterheadingposition) node [line width=2pt,rounded corners=15pt,draw=ocre,fill=white,fill opacity=0.5,inner sep=15pt]{\strut\makebox[\chaptermakebox]{}};
\draw[anchor=west] (\Gm@lmargin+.3cm,-\chapterheadingposition) node {\huge\sffamily\bfseries\color{black}#1\strut};
\end{tikzpicture}};
\end{tikzpicture}
\fi\fi\par\iftoggle{isprint}{\vspace*{240\p@}}{\vspace*{270\p@}}}}

%-------------------------------------------

\def\@makeschapterhead#1{%
\begin{tikzpicture}[remember picture,overlay]
\node at (current page.north west)
{\begin{tikzpicture}[remember picture,overlay]
\node[anchor=north west,inner sep=0pt] at (0,0) {\includegraphics[width=\paperwidth]{\thechapterimage}};
\draw[anchor=west] (\Gm@lmargin,-\chapterheadingposition) node [line width=2pt,rounded corners=15pt,draw=ocre,fill=white,fill opacity=0.5,inner sep=15pt]{\strut\makebox[\chaptermakebox]{}};
\draw[anchor=west] (\Gm@lmargin+.3cm,-\chapterheadingposition) node {\huge\sffamily\bfseries\color{black}#1\strut};
\end{tikzpicture}};
\end{tikzpicture}
\par\iftoggle{isprint}{\vspace*{190\p@}}{\vspace*{250\p@}}}

%--------------------------------------------

\crefname{part}{Part}{Parts}
\crefname{chapter}{Chapter}{Chapters}

% \chapter clears the page by itself, so let's not have \include do that as well.
\makeatletter
\patchcmd{\@include}{\clearpage}{}{}{}
\makeatother

% The previous change to \chapter also affects \tableofcontents---effectively undo this change
\let\oldtableofcontents\tableofcontents
\renewcommand{\tableofcontents}{\clearpage\oldtableofcontents}

% This code is in order to suppress any '0 sections' (e.g., so that it will not print eqn (2.0.1) if you have not begun a subsection of section 2 yet).  This must come after the chapter and section redefinitions above.
%\numberwithin{equation}{section}
\let\oldchapter\chapter% Store \chapter
\renewcommand{\chapter}{% Update \chapter
	\renewcommand{\theequation}{\thechapter.\arabic{equation}}% Update equation number
	\oldchapter}
\let\oldsection\section% Store \section
\renewcommand{\section}{% Update \section
	\renewcommand{\theequation}{\thesection.\arabic{equation}}% Update equation number
	\oldsection}% Regular \section