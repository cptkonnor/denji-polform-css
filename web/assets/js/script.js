document.addEventListener('DOMContentLoaded', function () {
    const form = document.getElementById('application-form');
    const formContainer = document.querySelector('.form-container');
    const successOverlay = document.getElementById('success-overlay');
    const successGif = document.querySelector('#success-overlay img');
    const questionsContainer = document.getElementById('questions-container');

    const formTitle = document.getElementById('form-title');
    const submitBtn = document.getElementById('submit-btn');
    const cancelBtn = document.getElementById('cancel-btn');

    window.addEventListener('message', function (event) {
        const { type, success, questions, locale } = event.data;
        switch (type) {
            case 'open':
                handleOpen(questions, locale);
                break;
            case 'submissionResult':
                if (success) {
                    handleSuccess();
                } else {
                    handleFailure();
                }
                break;
        }
    });

    function loadQuestions(questions) {
        questionsContainer.innerHTML = '';

        questions.forEach((questionData, index) => {
            const questionDiv = document.createElement('div');
            questionDiv.classList.add('question');

            const label = document.createElement('label');
            label.setAttribute('for', `question-${index}`);
            label.textContent = questionData.label;
            
            let input;
            if (questionData.type === 'textarea') {
                input = document.createElement('textarea');
            } else {
                input = document.createElement('input');
                input.type = questionData.type;
            }
            input.id = `question-${index}`;
            input.name = `question-${index}`;
            if (questionData.required) {
                input.required = true;
            }

            questionDiv.appendChild(label);
            questionDiv.appendChild(input);

            questionsContainer.appendChild(questionDiv);
        });
    }

    function closeNUI() {
        document.body.classList.remove('cursor-hidden');
        formContainer.classList.remove('fade-out');
        document.body.style.display = 'none';
        fetch(`https://${GetParentResourceName()}/close`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json; charset=UTF-8' },
            body: JSON.stringify({}),
        });
    }

    function handleOpen(questions, locale) {
        formTitle.textContent = locale.title;
        submitBtn.textContent = locale.submit;
        cancelBtn.textContent = locale.cancel;

        document.body.classList.remove('cursor-hidden');
        formContainer.classList.remove('fade-out');
        document.body.style.display = 'flex';
        formContainer.style.display = 'block';
        form.reset();
        loadQuestions(questions);
    }

    function handleSuccess() {
        document.body.classList.add('cursor-hidden');
        formContainer.classList.add('fade-out');
        formContainer.addEventListener('transitionend', () => {
            formContainer.style.display = 'none';
            successGif.src = successGif.src;
            successOverlay.classList.remove('hidden');
            successOverlay.classList.add('visible');
            setTimeout(() => {
                successOverlay.classList.remove('visible');
                successOverlay.addEventListener('transitionend', closeNUI, { once: true });
            }, 1500);
        }, { once: true });
    }

    function handleFailure() {
        closeNUI();
    }
    
    function handleCancel() {
        formContainer.classList.add('fade-out');
        formContainer.addEventListener('transitionend', () => {
            closeNUI();
        }, { once: true });
    }

    form.addEventListener('submit', function (event) {
        event.preventDefault();
        const formData = new FormData(form);
        const answers = {};
        for (const [key, value] of formData.entries()) {
            answers[key] = value;
        }
        fetch(`https://${GetParentResourceName()}/submit`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json; charset=UTF-8' },
            body: JSON.stringify(answers),
        });
    });

    cancelBtn.addEventListener('click', function(event) {
        event.preventDefault();
        handleCancel();
    });

    document.addEventListener('keydown', function(event) {
        if (event.key === 'Escape') {
            handleCancel();
        }
    });
});