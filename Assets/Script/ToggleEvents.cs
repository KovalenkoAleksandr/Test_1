using System;
using UnityEngine;
using UnityEngine.Events;
using UnityEngine.Serialization;
using UnityEngine.UI;


public class ToggleEvents : MonoBehaviour
{
    [SerializeField] private bool _autoplay;
    [SerializeField] private UnityEvent _onToggleOn;
    [SerializeField] private UnityEvent _onToggleOff;

    private Toggle _toggle;
    void Awake()
    {
        _toggle = GetComponent<Toggle>();
        _toggle.onValueChanged.AddListener(OnValueChanged);
    }

    private void OnEnable()
    {
        if (_autoplay)
            OnValueChanged(_toggle.isOn);
    }


    private void OnValueChanged(bool value)
    {
        if (value)
            _onToggleOn.Invoke();
        else
            _onToggleOff.Invoke();
    }
}