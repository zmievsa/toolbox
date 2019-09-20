function clicker() {
    // Automatically does the boring portion of my homework in CS course
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
    main();
} clicker()