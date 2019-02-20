using System.Collections;
using UnityEngine.UI;
using System.Collections.Generic;
using UnityEngine;

public class CubeCounter : MonoBehaviour {

    public Text countText;
    public Text winText;
    private int count;
    public GameObject pickupeffect;
    public GameObject DoorTrigger;
    public GameObject Quit;

    void Start()
    {
        count = 0;
        SetCountText();
        winText.text = "";
    }
    void OnTriggerEnter(Collider other)
    {
        if(other.gameObject.CompareTag ("Pick Up"))
        {
            Instantiate(pickupeffect, transform.position, transform.rotation);
            other.gameObject.SetActive(false);
            count = count + 1;
            Debug.Log(count);
            SetCountText();
        }
    }

    void SetCountText()
    {
        countText.text = "# of cubes picked up: " + count.ToString();
        if(count >= 5)
        {
            winText.text = "You Win! Door is now opened!";
            Debug.Log("Door Open");
            DoorTrigger.SetActive(true);
            Quit.SetActive(true);
        }
    }
}
