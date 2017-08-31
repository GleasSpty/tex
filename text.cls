% Heaviliy modified version of the Legrand Orange Book template (https://www.latextemplates.com/template/the-legrand-orange-book)

\ProvidesClass{text}
\RequirePackage{xkeyval}
\RequirePackage{etoolbox}
\RequirePackage{regexpatch}

\apptocmd{\title}{\def\@titleisdefined{\relax}}{}{}
\apptocmd{\author}{\def\@authorisdefined{\relax}}{}{}
\apptocmd{\date}{\def\@dateisdefined{\relax}}{}{}

% Use \iftoggle{isprint}{<If true>}{<If false>} to write code depending on whether this is electronic or print
\newtoggle{isprint} % Default is false
\newtoggle{titlepage}
\toggletrue{titlepage}
\newtoggle{oneside}
\toggletrue{oneside}
\newtoggle{showsolutions}

% There are two 'modes':  the default and "print" mode, which is intended for when you want to make an actual print book.  Print mode is used by passing the mode "print".  Among other things, print mode changes to a two-sided layout and disables the title page.  You can change the ordinary behavior of "default" mode and "print" mode by passing the following options to enable or disable a two-sided layout and title page.
\DeclareOptionX{print}{\toggletrue{isprint}\togglefalse{titlepage}\togglefalse{oneside}}
\DeclareOptionX{oneside}{\toggletrue{oneside}}
\DeclareOptionX{nooneside}{\togglefalse{oneside}}
\DeclareOptionX{twoside}{\togglefalse{oneside}}
\DeclareOptionX{title}{\toggletrue{titlepage}}
\DeclareOptionX{notitle}{\togglefalse{titlepage}}
\DeclareOptionX{solutions}{\toggletrue{showsolutions}}
\DeclareOptionX*{\PassOptionsToClass{\CurrentOption}{book}}
\ProcessOptionsX%

\iftoggle{isprint}{%
	\iftoggle{oneside}{%
		\LoadClass[11pt,fleqn,oneside]{book}%
	}
	{%
		\LoadClass[11pt,fleqn]{book}%
	}
}%
{%
	\LoadClass[12pt,fleqn,oneside]{book}%
}%

%----------------------------------------------------------------------------------------
%	BIBLIOGRAPHY AND INDEX
%----------------------------------------------------------------------------------------

\usepackage[style=alphabetic]{biblatex}
\addbibresource{bibliography.bib}

\usepackage{imakeidx} % Required to make an index
\makeindex
\makeindex[name=notation,title=Index of notation,columns=3]
% The below 'executes' \apptocmd{\hyperpage}{\vspace{0pt plus 0pt minus 4pt}}{}{} before it prints the notation index.  Each index entry ends with a \hyerpage command, and so this helps prevent overfull vboxes.  Looks too bad to use with the normal index, so only use this for notation index.  Change the glue values as needed.
\xpretocmd{\printindex}{%
	\ifthenelse{\equal{\detokenize{#1}}{\detokenize{notation}}}{\apptocmd{\hyperpage}{\vspace{0pt plus 0pt minus 0pt}}{}{}}{}
}%
{}%
{}

\iftoggle{isprint}{%
	\iftoggle{oneside}{%
		\usepackage[paperwidth=6in,paperheight=9in,left=.9375in,right=.9375in,top=1.0in,bottom=1.0in,headsep=10pt]{geometry} % Page margins
	}{%
		\usepackage[paperwidth=6in,paperheight=9in,inner=1.125in,outer=0.75in,top=1.0in,bottom=1.0in,headsep=10pt,twoside]{geometry} % Page margins
	}
}
{%
	\iftoggle{oneside}{%
		\usepackage[top=4cm,bottom=4cm,left=4cm,right=4cm,headsep=10pt,a4paper]{geometry} % Page margins
	}{%
		\usepackage[top=4cm,bottom=4cm,left=4cm,right=4cm,headsep=10pt,a4paper,twoside]{geometry} % Page margins
	}
}

\RequirePackage{custom} % fancyhdr needs to come *after* geometry

\iftoggle{titlepage}{%
	\AtBeginDocument{%
		\ifboolexpr{test {\ifdef{\@titleisdefined}} or test {\ifdef{\@authorisdefined}}}{%
			\pagenumbering{gobble}% Don't number title page with hyperref.  Otherwise, will complain about duplicate destinations with name page.1
			\begingroup
			\thispagestyle{empty}
			\newlength{\titledisplacement}
			\iftoggle{isprint}{\setlength{\titledisplacement}{8cm}}{\setlength{\titledisplacement}{12cm}}
			\begin{tikzpicture}[remember picture,overlay]
			\coordinate [below=\titledisplacement] (midpoint) at (current page.north);
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
		}{}%
	}
	\AfterEndPreamble{\clearpage} % For some reason this throws error if placed in \AtBeginDocument.  (This is executed after the above.)
}{}

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
\newtoggle{usechapterimage}
\usepackage{extdash}
\newlength{\chaptermakebox}
\newlength{\chapterheadingposition}
\iftoggle{isprint}{\setlength{\chaptermakebox}{6.25in}\setlength{\chapterheadingposition}{2.7in}}{\setlength{\chaptermakebox}{22cm}\setlength{\chapterheadingposition}{9cm}}
\newcommand{\thechapterimage}{}%
\newcommand{\chapterimage}[1]{\renewcommand{\thechapterimage}{#1}\toggletrue{usechapterimage}}%
\def\@makechapterhead#1{%
{\parindent \z@ \raggedright \normalfont
\ifnum \c@secnumdepth >\m@ne
\if@mainmatter
\begin{tikzpicture}[remember picture,overlay]
\node at (current page.north west)
{\begin{tikzpicture}[remember picture,overlay]
	\node[anchor=north west,inner sep=0pt] at (0,0) {\iftoggle{usechapterimage}{\includegraphics[width=\paperwidth]{\thechapterimage}}{}};
	\draw[anchor=west] (\Gm@lmargin,-\chapterheadingposition) node [line width=2pt,rounded corners=15pt,draw=ocre,fill=white,fill opacity=0.5,inner sep=15pt]{\strut\makebox[\chaptermakebox]{}\vphantom{\parbox{\chaptermakebox-8cm}{\huge\sffamily\bfseries\color{black}\thechapter. #1\strut}}};
	\draw[anchor=west] (\Gm@lmargin+.3cm,-\chapterheadingposition) node {\parbox{\chaptermakebox-8cm}{\huge\sffamily\bfseries\color{black}\thechapter. #1\strut}};
	\end{tikzpicture}};
\end{tikzpicture}
\else
\begin{tikzpicture}[remember picture,overlay]
\node at (current page.north west)
{\begin{tikzpicture}[remember picture,overlay]
\node[anchor=north west,inner sep=0pt] at (0,0) {\iftoggle{usechapterimage}{\includegraphics[width=\paperwidth]{\thechapterimage}}{}};
\draw[anchor=west] (\Gm@lmargin,-\chapterheadingposition) node [line width=2pt,rounded corners=15pt,draw=ocre,fill=white,fill opacity=0.5,inner sep=15pt]{\strut\makebox[\chaptermakebox]{}};
\draw[anchor=west] (\Gm@lmargin+.3cm,-\chapterheadingposition) node {\huge\sffamily\bfseries\color{black}#1\strut};
\end{tikzpicture}};
\end{tikzpicture}
\fi\fi\par\iftoggle{isprint}{\vspace*{210\p@}}{\vspace*{270\p@}}}}

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
\patchcmd{\@include}{\clearpage}{}{}{}

% The previous change to \chapter also affects \tableofcontents---effectively undo this change
\let\oldtableofcontents\tableofcontents
\renewcommand{\tableofcontents}{\clearpage\oldtableofcontents}

% This code is in order to suppress any '0 sections' (e.g., so that it will not print eqn (2.0.1) if you have not begun a subsection of section 2 yet).  This must come after any chapter, section, etc. redefinitions above.
\let\oldchapter\chapter% Store \chapter
\renewcommand{\chapter}{% Update \chapter
	\renewcommand{\theequation}{\thechapter.\arabic{equation}}% Update equation number
	\oldchapter}
\let\oldsection\section% Store \section
\renewcommand{\section}{% Update \section
	\renewcommand{\theequation}{\thesection.\arabic{equation}}% Update equation number
	\oldsection}% Regular \section
\let\oldsubsection\subsection% Store \subsection
\renewcommand{\subsection}{% Update \subsection
	\renewcommand{\theequation}{\thesubsection.\arabic{equation}}% Update equation number
	\oldsubsection}% Regular \section


% Modifies "solution" environment to only display if the option "solutions" has been provided.
\let\oldsolution\solution
\let\oldendsolution\endsolution
\let\old@beforebegin@solution@hook\@beforebegin@solution@hook % Need to redefine the previous hooks used separately.
\let\@beforebegin@solution@hook\undefined % (Name of hooks found in etoolbox.sty.)
\let\old@begin@solution@hook\@begin@solution@hook
\let\@begin@solution@hook\undefined
\let\old@afterend@solution@hook\@afterend@solution@hook
\let\@afterend@solution@hook\undefined
\let\old@end@solution@hook\@end@solution@hook
\let\@end@solution@hook\undefined
\RenewEnviron{solution}{%
	\iftoggle{showsolutions}{\oldsolution \BODY \oldendsolution}{}%	
}
\def\@beforebegin@solution@hook{\iftoggle{showsolutions}{\old@beforebegin@solution@hook}{}}
\def\@begin@solution@hook{\iftoggle{showsolutions}{\old@begin@solution@hook}{}}
\def\@afterendsolution@hook{\iftoggle{showsolutions}{\old@afterend@solution@hook}{}}
\def\@end@solution@hook{\iftoggle{showsolutions}{\old@end@solution@hook}{}}
