function clicker() {
    const list_observer_config = {childList: true};
    const step_observer_config = {attributes: true}
    function main() {
        anims = document.getElementsByClassName("animation-controls")
        for (a of anims) {
            a.children[1].children[0].children[0].checked = true
            new MutationObserver(listMutationCallback).observe(a, list_observer_config);
            a.children[0].click()
        }
        for (root of document.getElementsByClassName("multiple-choice-question")) {
            el = root.getElementsByClassName("explanation")[0]
            new MutationObserver(multipleChoiceCallback).observe(el, {childList: true})
            root.children[0].children[1].children[0].children[0].click()
        }
        for (root of document.getElementsByClassName("short-answer-question")) {
            show_answer_btn = root.getElementsByClassName("show-answer-button")[0]
            alert = root.getElementsByClassName("explanation")[0]
            new MutationObserver(shortAnswerCallback).observe(alert, {attributes: true})
            show_answer_btn.click(); show_answer_btn.click();
        }
    }
    function listMutationCallback(mutationsList, observer) {
        
        for (mutation of mutationsList) {
            n = mutation.addedNodes[0]
            if (n && n.classList && n.classList.contains("step")) {
                new MutationObserver(stepMutationCallback).observe(n.nextSibling, step_observer_config)
                break
            }
        }
        console.log("Steps have appeared. Disconnecting.")
        observer.disconnect()
    }
    function stepMutationCallback(mutationsList, observer) {
        for (mutation of mutationsList) {
            n = mutation.target
            if (n.nextSibling.classList.contains("step"))
                new MutationObserver(stepMutationCallback).observe(n.nextSibling, step_observer_config)
            n.click()
            break
        }
        console.log("Step is finished. Disconnecting.")
        observer.disconnect()
    }
    function multipleChoiceCallback(lst, obs) {
        for (m of lst) {
            if ((n=m.addedNodes[0]) && n.classList && n.classList.contains("message")) {
                if (n.textContent.includes("Incorrect")) {
                    prev_sibl = m.target.parentElement
                    els = prev_sibl.getElementsByClassName("zb-radio-button")
                    
                    for (el of els) {
                        if (el.children[0].checked) {
                            sib = el.nextElementSibling
                            sib.children[0].click()
                            break
                        }
                    }
                }
                else {
                    console.log("The answer was correct. Disconnecting.")
                    obs.disconnect()
                }
            }
        }
    }
    function shortAnswerCallback(lst, obs) {
        for (m of lst) {
            alert = m.target
            if (alert.classList.contains("forfeit")) {
                answer = alert.getElementsByClassName("forfeit-answer")[0].innerText
                obs.disconnect()
                console.log("Found the right answer. Disconnecting")
                root = alert.parentElement
                text_area = root.getElementsByClassName("zb-text-area")[0]
                text_area.value = answer.trim()
            }
        }
    }
    main();
} clicker()
