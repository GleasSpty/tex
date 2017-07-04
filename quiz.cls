\ProvidesClass{quiz}
\RequirePackage{fancyhdr}

% Taken from mathexam.dtx

\newif\ifExamHdr
\ExamHdrtrue
\DeclareOption{nohdr}{\ExamHdrfalse}

\DeclareOption*{\PassOptionsToClass{\CurrentOption}{exam}}
\ProcessOptions\relax

\ifExamHdr
\RequirePackage{lastpage}
\RequirePackage{ifthen}
\fi

\LoadClass[addpoints]{exam}

\usepackage[top=3cm,bottom=3cm,left=3cm,right=3cm,headsep=10pt,a4paper]{geometry} % Page margins

\newcommand{\ExamName}[1]{\def\@xamname{#1}}
\newcommand{\ExamClass}[1]{\def\@xamclass{#1}}
\newcommand{\ExamHead}[1]{\def\@xamrighthdr{#1}}

\def\@xamname{\relax}
\def\@xamclass{\relax}
\def\@xamrighthdr{\relax}

\ifExamHdr

\pagestyle{fancy}
\lhead{\@xamclass}
\chead{\@xamname}

\AtBeginDocument{
	\begin{center}
		\large\scshape \@xamclass \hfill \@xamname \hfill \@xamrighthdr
\end{center}}

\thispagestyle{empty}
\fi

\renewcommand{\thefootnote}{\alph{footnote}\,} % Change footnotes to use letters instead of numbers to make it less likely that people will mistake the footnote for other things

\newcommand{\ExamNameLine}{%
	\par
	\vspace{\baselineskip}
	Name:\hrulefill\relax
	\par}

\newcommand{\ExamInstrBox}[1]{\begin{center}\vspace{\baselineskip}%
		\fbox{\fbox{\parbox{.8\hsize}{#1}}}\end{center}}
	
%%%%

\RequirePackage{custom}