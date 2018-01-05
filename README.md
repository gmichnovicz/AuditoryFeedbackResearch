# AuditoryFeedbackResearch

This research project seeks to investigate the possibility that a background of musical training enhances or otherwise alters auditory feedback processing during speech by using two feedback manipulation paradigms: pitch-shifted auditory feedback as well as delayed auditory feedback.

Code included in this repository is used for the first half of the research project - the investigation and evaluation of musical background/abilities. Simulations were created using MATLAB and PsychToolBox. Audio presentation was maintained using a MOTO Microbook II and transmitted over Sennheiser HD280 pro Closed Ear Headphones. Audio input was taken using a Shure WH30XLR head worn condenser microphone.

Code included: Music Perception Tasks

1. Survey

Survey adapted with questions from "Müllensiefen, D., Gingras, B., Musil, J., & Stewart L. (2014). The Musicality of Non-Musicians: An Index for Assessing Musical Sophistication in the General Population. PLoS ONE, 9(2): e89642. doi:10.1371/journal.pone.0089642". Adapted an interface in order to collect user responses and auto-grade their score based on responses, as well as save it all automatically.

2. Tone Discrimination Task 

Code generated to produce an adaptive procedure to evaluate what is known as "just noticeable difference" in terms of differentiating two sequential tones. A "two-up one-down" procedure was implemented - meaning for every two correct responses the task gets harder, for every incorrect response the task gets easier. The task tracks the amount of pre-set reversals and auto-generates the frequency difference the specific user can hear accordingly - meaning the task is catered to the user's abilities. Must have PsychToolBox libraries installed to use. Includes additional code for generating tones and evaluating responses.

3. Interval Discrimination Task

Very similar to the tone discrimination task in format, yet for user to differentiate between two-tone intervals. User must also have PyschToolBox libraries installed. Includes additional code for generating tone sequences and evaluating user responses.

4. Pitch Matching Task

Generates random sequences of tones in the equal-tempered musical scale to be presented to the user to vocally reproduce. Code included generates the sequences and presents them with visual stimuli for reproduction purposes. Automatically records and saves responses in separate organized files.
