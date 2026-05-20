using System.Collections.Generic;
using UnityEngine;
using Meta.XR.MRUtilityKit;

public class QRCodeManager : MonoBehaviour
{
    [System.Serializable]
    public struct QREntry
    {
        public string qrValue; // El texto que esperas leer del QR
        public GameObject prefab; // El modelo 3D a mostrar
    }

    [SerializeField]
    public List<QREntry> qrLibrary; // Configura esto en el Inspector

    //Util para no tener que buscar en la lista, sino por palabra clave (un diccionario)
    private Dictionary<string, QREntry> qrLibraryDictionary = new Dictionary<string, QREntry>();

    [SerializeField]
    MRUK _mrukInstance;

    private void OnEnable()
    {
        if (!_mrukInstance)
        {
            Debug.Log($"{nameof(QRCodeManager)} requires an MRUK object in the scene!");
            return;
        }

        _mrukInstance.SceneSettings.TrackableAdded.AddListener(OnTrackableAdded);
        _mrukInstance.SceneSettings.TrackableRemoved.AddListener(OnTrackableRemoved);
    }

    private void Start()
    {
        //Se rellena el diccionario con los que hay en la lista prefijada
        foreach (var qrEntry in qrLibrary)
        {
            qrLibraryDictionary.Add(qrEntry.qrValue, qrEntry);
        }
    }

    public void OnTrackableAdded(MRUKTrackable trackable)
    {
        //Se comprueba que se ha leido un QR y que tiene contenido
        if (trackable.TrackableType != OVRAnchor.TrackableType.QRCode && trackable.MarkerPayloadString != null)
        {
            return;
        }

        //Se lee el texto que contiene
        string qrString = trackable.MarkerPayloadString;

        //Se busca si el texto está en la librería de QRs
        if (qrLibraryDictionary.TryGetValue(qrString, out QREntry qrEntry))
        {
            //Se coloca el objeto asociado en la posición del QR
            qrEntry.prefab.transform.SetPositionAndRotation(trackable.transform.position, trackable.transform.rotation);
            //Se enlaza como hijo el objeto asociado al QR, para que se actualice su posición automáticamente
            qrEntry.prefab.transform.SetParent(trackable.transform);
            //Muestra el objeto asociado al QR
            qrEntry.prefab.SetActive(true);
        }
    }

    public void OnTrackableRemoved(MRUKTrackable trackable)
    {
        if (trackable.TrackableType != OVRAnchor.TrackableType.QRCode)
        {
            return;
        }

        string qrString = trackable.MarkerPayloadString;

        if (qrLibraryDictionary.TryGetValue(qrString, out QREntry qrEntry))
        {
            qrEntry.prefab.SetActive(false);
        }

        Destroy(trackable.gameObject);
    }
}