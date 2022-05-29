using UnityEngine;
using UnityEngine.UI;

public class SortingOrderEvent : MonoBehaviour
{
    [SerializeField] private int _sortingOrder;

    private Canvas _canvas;
    private GraphicRaycaster _raycaster;
    
    public void ChangeSortingOrder()
    {
        _canvas = gameObject.AddComponent<Canvas>();
        _raycaster = gameObject.AddComponent<GraphicRaycaster>();
        _canvas.overrideSorting = true;
        _canvas.sortingOrder = _sortingOrder;
    }

    public void RemoveSortingOrder()
    {
        Destroy(_canvas);
        Destroy(_raycaster);
    }
}